//
//  NetworkService.swift
//  PockemonList
//
//  Created by ivan.dekhtiarov on 22/08/2022.
//

import Foundation

enum NetworkError: Error {
    case noData
}

protocol NetworkService {
    
    func fetchData(
        url: URL,
        completion: @escaping (Result<Data, Error>) -> Void
    )
    
    func fetchItems<T: Decodable>(
        url: URL,
        completion: @escaping (Result<T, Error>) -> Void
    )
    
}

class NetworkServiceImpl: NetworkService {
    
    private let completionQueue: DispatchQueue
    private let urlSession: URLSession
    private var dataTask: URLSessionDataTask?
    
    init(
        completionQueue: DispatchQueue = DispatchQueue.main,
        urlSession: URLSession
    ) {
        self.completionQueue = completionQueue
        self.urlSession = urlSession
    }
    
    func fetchData(
        url: URL,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        dataTask?.cancel()
        
        dataTask = urlSession.dataTask(with: url) { [weak self] data, resonse, error in
            defer {
                self?.dataTask = nil
            }
            if let error = error {
                self?.completionQueue
                    .async { completion(.failure(error)) }
            } else if let data = data {
                self?.completionQueue
                    .async { completion(.success(data)) }
            } else {
                self?.completionQueue
                    .async { completion(.failure(NetworkError.noData)) }
            }
            
        }
        
        dataTask?.resume()
    }
    
    func fetchItems<T: Decodable>(
        url: URL,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        fetchData(url: url) { result in
            switch result {
            case .success(let jsonData):
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: jsonData)
                    completion(.success(result))
                } catch(let error) {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
}
