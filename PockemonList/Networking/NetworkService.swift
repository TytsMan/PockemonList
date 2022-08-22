//
//  NetworkService.swift
//  PockemonList
//
//  Created by ivan.dekhtiarov on 22/08/2022.
//

import Foundation

protocol NetworkService {
    func fetchData(
        url: URL,
        completion: @escaping (Result<Data, Error>) -> Void
    )
}

class NetworkServiceImpl: NetworkService {
    
    let requestQueue: DispatchQueue
    let completionQueue: DispatchQueue
    
    init(
        requestQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated),
        completionQueue: DispatchQueue = DispatchQueue.main
    ) {
        self.requestQueue = requestQueue
        self.completionQueue = completionQueue
    }
    
    func fetchData(
        url: URL,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        requestQueue
            .async { [completionQueue] in
                
                URLSession.shared.dataTask(with: url) { data, resonse, error in
                    
                    if let error = error {
                        completionQueue
                            .async {
                                completion(.failure(error))
                            }
                        return
                    }
                    
                    guard let data = data else {
                        fatalError("Data cannot be found")
                    }
                    
                    completionQueue
                        .async {
                            completion(.success(data))
                        }
                    
                }.resume()
            }
    }
    
}
