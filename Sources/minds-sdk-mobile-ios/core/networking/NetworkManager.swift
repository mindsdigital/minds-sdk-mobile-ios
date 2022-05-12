//
//  NetworkService.swift
//  
//
//  Created by Vinicius Salmont on 05/05/22.
//

import Foundation
import Combine

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
    case apiError(code: Int, error: String)
    case invalidJSON(error: String)
    case unauthorized(code: Int, error: String)
    case badRequest(code: Int, error: String)
    case serverError
    case noResponse(_ error: String)
    case unableToParseData(_ error: String)
    case unknown(code: Int, error: String)
    
    var message: String {
        switch self {
        case .badURL: return "🌏💥 Invalid URL"
        case .apiError(let code, let error): return "API ERROR 🧨💥 CODE: \(code) ERROR: \(error)"
        case .invalidJSON(let error): return "MINDS SDK: ❌ Invalid JSON: \(error)"
        case .serverError: return "MINDS SDK: ❌ Server Error ❌"
        default: return "🤷‍♂️ Unknown Error"
            
        }
    }
}

protocol Requestable {
    var requestTimeout: Float { get }
    
    func request<T: Codable>(_ request: NetworkRequest) -> AnyPublisher<T, NetworkError>
}

class NetworkManager: Requestable {
    var requestTimeout: Float = 30
    
    public func request<T>(_ request: NetworkRequest) -> AnyPublisher<T, NetworkError> where T: Decodable, T: Encodable {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = TimeInterval(request.requestTimeout ?? requestTimeout)
        
        guard let url = URL(string: request.url) else {
            return AnyPublisher(Fail<T, NetworkError>(error: .badURL))
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: request.buildURLRequest(with: url))
            .tryMap { output in
                guard output.response is HTTPURLResponse else {
                    throw NetworkError.serverError
                }
                
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                NetworkError.invalidJSON(error: String(describing: error))
            }
            .eraseToAnyPublisher()
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
