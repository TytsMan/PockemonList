//
//  PokemonCardAPIManager.swift
//  PockemonList
//
//  Created by ivan.dekhtiarov on 19/08/2022.
//

import Foundation

protocol PokemonCardAPIManager {
    func getPokemonCards(
        with completionHandler: @escaping (Result<[PokemonCard], Error>)->Void
    )
}

class PokemonCardAPIManagerImpl: PokemonCardAPIManager {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    enum InternetProtocol: String {
        case http, https //,ftp
    }
    
    enum EngineVersion: String {
        case v1, v2
    }
    
    enum EndPoint: String {
        case cards
    }
    
    private static let domain = "api.pokemontcg.io"
    
    func getPokemonCards(
        with completionHandler: @escaping (Result<[PokemonCard], Error>)->Void
    ) {
        let url = getUrl(endPoint: .cards)
        fetchItems(url: url, completion: completionHandler)
    }
    
    private func getUrl(
        for internetProtocol: InternetProtocol = .https,
        engineVersion: EngineVersion = .v2,
        endPoint: EndPoint
    ) -> URL {
        let urlString = internetProtocol.rawValue +
        PokemonCardAPIManagerImpl.domain +
        engineVersion.rawValue +
        endPoint.rawValue
        let url = URL(string: urlString)!
        return url
    }
    
    private func fetchItems<T: Decodable>(
        url: URL,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        networkService
            .fetchData(url: url) { result in
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

