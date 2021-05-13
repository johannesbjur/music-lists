//
//  AuthManager.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-09.
//

import Foundation

final class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var isSignedIn: Bool

    private var refreshingToken = false

    init() {
        isSignedIn = UserDefaults.standard.string(forKey: "access_token") != nil
    }
    
    private struct Constants {
        static let clientID = "1b3a3e3d826549a1a08e3c89988b7e6d"
        static let clientSecret = "00be042ea9aa4102a24f5f48fac7f2a9"
        static let baseURLString = "https://accounts.spotify.com"
        static let redirectURI = "https://github.com/johannesbjur"
    }
    
    public var signInURL: URL? {
        let base = "\(Constants.baseURLString)/authorize"
        let scopes = "user-read-private%20user-top-read%20playlist-read-private%20playlist-modify-public%20playlist-modify-private"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=true"
        
        return URL(string: string)
    }
    
    var tokenApiURL: URL? {
        let string = "\(Constants.baseURLString)/api/token"
        
        return URL(string: string)
    }

    func updateSignedIn() {
        DispatchQueue.main.async {
            self.isSignedIn = UserDefaults.standard.string(forKey: "access_token") != nil
        }
    }

    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }

    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }

    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expiration") as? Date
    }

    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else { return false }
        let fiveMinutes: TimeInterval = 300
        let currentDate = Date()
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }

    public func exangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
        guard let url = tokenApiURL else { return }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = "\(Constants.clientID):\(Constants.clientSecret)"
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failed to get Base 64 token")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.chacheToken(result: result)
                
                completion(true)
            }
            catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }

    private var onRefreshBlocks = [((String) -> Void)]()

    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        if shouldRefreshToken {
            refreshIfNeeded { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
        }
        else if let token = accessToken {
            completion(token)
        }
    }

    public func refreshIfNeeded(completion: @escaping (Bool) -> Void) {
        guard !refreshingToken else {
            return
        }
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        guard let refreshToken = self.refreshToken else { return }
        guard let url = tokenApiURL else { return }

        refreshingToken = true

        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)

        let basicToken = "\(Constants.clientID):\(Constants.clientSecret)"
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failed to get Base 64 token")
            completion(false)
            return
        }

        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("Successfully refreshed token")
                self?.onRefreshBlocks.forEach{ $0(result.access_token) }
                self?.onRefreshBlocks.removeAll()
                self?.chacheToken(result: result)
                completion(true)
            }
            catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    private func chacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expiration")
    }

    func signOut() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        updateSignedIn()
    }
    
}
