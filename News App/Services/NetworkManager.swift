//
//  NetworkManager.swift
//  Assignment12
//
//  Created by Pranab Raj Satyal on 7/8/21.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func fetchData<T: Codable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.isValidResponse() else { return }
            
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
                
            } catch let error {
                completion(.failure(error))
            }
            
        }.resume()
        
    }
    
}
