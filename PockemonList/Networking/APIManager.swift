//
//  APIManager.swift
//  PockemonList
//
//  Created by ivan.dekhtiarov on 19/08/2022.
//

import Foundation

class APIManager {
    
    static let shared = APIManager()
    
    private init() { }
    
    func fetchItems<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, resonse, error in
            
            // check for background queue
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let jsonData = data else {
                fatalError("Data cannot be found")
            }

            do {
                let result = try JSONDecoder().decode(T.self, from: jsonData)
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
            } catch(let error) {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
