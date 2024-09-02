//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Neha Kukreja on 31/08/24.
//

import Foundation

class NetworkManager {
    
    private let baseURL: String = "https://newsapi.org/v2/"
    
    func getApiKey() -> String {
        return "663988f253f1419a821b9d2675e120b0"
    }
    
    func get<T: Decodable>(endpoint: String, responseType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let url = URL(string: baseURL + endpoint)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
    
    func post<T: Encodable, U: Decodable>(endpoint: String, body: T, responseType: U.Type, completion: @escaping (Result<U, NetworkError>) -> Void) {
        let url = URL(string: baseURL + endpoint)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(.encodingError(error)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(U.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
}

// Enum for network errors
enum NetworkError: Error {
    case networkError(Error)
    case decodingError(Error)
    case encodingError(Error)
    case noData
}

// Example usage
struct ExampleResponse: Decodable {
    let id: Int
    let name: String
}

struct ExampleRequest: Encodable {
    let name: String
}
