//
//  NetworkService.swift
//  
//
//  Created by Vinicius Salmont on 05/05/22.
//

import Foundation
import Combine
import Sentry

struct NetworkRequest {
    let url: String
    let headers: [String : String]?
    let body: Data?
    let requestTimeout: Float?
    let httpMethod: HTTPMethod
    
    init(url: String,
         headers: [String: String]? = nil,
         body: Encodable? = nil,
         requestTimeout: Float? = nil,
         httpMethod: HTTPMethod) {
        self.url = url
        self.headers = headers
        self.body = body?.encode()
        self.requestTimeout = requestTimeout
        self.httpMethod = httpMethod
    }
    
    init(url: String,
         headers: [String: String]? = nil,
         body: Data? = nil,
         requestTimeout: Float? = nil,
         httpMethod: HTTPMethod) {
        self.url = url
        self.headers = headers
        self.body = body
        self.requestTimeout = requestTimeout
        self.httpMethod = httpMethod
    }
    
    func buildURLRequest(with url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers ?? [:]
        urlRequest.httpBody = body
        return urlRequest
    }
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

enum NetworkError: Error, Equatable {
    case badURL
    case apiError(error: String)
    case invalidJSON(error: String)
    case serverError
    case invalidToken

    var message: String {
        switch self {
        case .badURL: return "🌏💥 Invalid URL"
        case .apiError(let error): return "API ERROR 🧨💥ERROR: \(error)"
        case .invalidJSON(let error): return "MINDS SDK: ❌ Invalid JSON: \(error)"
        case .serverError: return "MINDS SDK: ❌ Server Error ❌"
        case .invalidToken: return "Invalid Token"
        }
    }

    var description: String {
        switch self {
        case .badURL: return "Invalid url"
        case .apiError: return "API error"
        case .invalidJSON: return "Invalid Json"
        case .serverError: return "Server error"
        case .invalidToken: return "Invalid token"
        }
    }

    var code: Int {
        switch self {
        case .badURL: return 400
        case .apiError: return 500
        case .invalidJSON: return 500
        case .serverError: return 500
        case .invalidToken: return 401
        }
    }
}

protocol Requestable {
    var requestTimeout: Float { get }
    
    func request<T: Codable>(_ request: NetworkRequest, completion: @escaping (Result<T, NetworkError>) -> Void)
}

class NetworkManager: Requestable {
    var requestTimeout: Float

    init(requestTimeout: Float) {
        self.requestTimeout = requestTimeout
    }
    
    func request<T>(_ request: NetworkRequest, completion: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable, T: Encodable {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = TimeInterval(request.requestTimeout ?? requestTimeout)
        
        guard let url = URL(string: request.url) else {
            completion(.failure(.badURL))
            return
        }
        
        return URLSession.shared.dataTask(with: request.buildURLRequest(with: url)) { data, response, error in
            if let error = error {
                print(#function, "🧨 Request: \(request)\nError: \(error)")
                SentrySDK.capture(error: error)
                completion(.failure(.apiError(error: String(describing: error))))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.serverError))
                return
            }

            if httpResponse.statusCode == 401 {
                completion(.failure(.invalidToken))
                return
            }


            guard let data = data else {
                completion(.failure(.serverError))
                return
            }

            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                completion(.success(response))
            } catch let error {
                print(#function, "🧨 Request: \(request)\nError: \(error)")
                SentrySDK.capture(error: error)
                completion(.failure(.invalidJSON(error: String(describing: error))))
            }
        }
        .resume()
    }
}

extension Encodable {

    func encode() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            return nil
        }
    }

}
