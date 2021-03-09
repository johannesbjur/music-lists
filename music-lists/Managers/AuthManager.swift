//
//  AuthManager.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-09.
//

import Foundation

final class AuthManager {
    
    static let shared = AuthManager()
    
    private struct Constants {
        static let clientID = "1b3a3e3d826549a1a08e3c89988b7e6d"
        static let clientSecret = "00be042ea9aa4102a24f5f48fac7f2a9"
        static let baseURLString = "https://accounts.spotify.com"
        static let redirectURI = "https://github.com/johannesbjur"
    }
    
    public var signInURL: URL? {
        let base = "\(Constants.baseURLString)/authorize"
        let scopes = "user-read-private"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=true"
        
        return URL(string: string)
    }
    
    var tokenApiURL: URL? {
        let string = "\(Constants.baseURLString)/api/token"
        
        return URL(string: string)
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
    
    private func refreshToken() {
        
    }
    
    private func chacheToken(result: AuthResponse) {
    
    }
    
}
