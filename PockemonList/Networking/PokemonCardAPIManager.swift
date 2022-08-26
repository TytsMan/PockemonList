//
//  PokemonCardAPIManager.swift
//  PockemonList
//
//  Created by ivan.dekhtiarov on 19/08/2022.
//

import Foundation

protocol PokemonCardAPIManager {
    func getPokemonCards(
        completion: @escaping (Result<[PokemonCard], Error>) -> Void
    )
}

class PokemonCardAPIManagerImpl: PokemonCardAPIManager {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    enum InternetProtocol: String {
        case http
        case https
        //,ftp
    }
    
    enum EngineVersion: String {
        case v1, v2
    }
    
    enum EndPoint: String {
        case cards
    }
    
    private static let domain = "api.pokemontcg.io"
    
    func getPokemonCards(
        completion: @escaping (Result<[PokemonCard], Error>) -> Void
    ) {
        
        let url = getUrl(endPoint: .cards)
        let fetchHandler: (Result<PokemonCardResponce, Error>) -> Void = { result in
            switch result {
            case .success(let responce):
                completion(.success(responce.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        networkService.fetchItems(
            url: url,
            completion: fetchHandler
        )
        
    }
    
    private func getUrl(
        for internetProtocol: InternetProtocol = .https,
        engineVersion: EngineVersion = .v2,
        endPoint: EndPoint
    ) -> URL {
        let urlString =
        internetProtocol.rawValue + "://" +
        PokemonCardAPIManagerImpl.domain + "/" +
        engineVersion.rawValue + "/" +
        endPoint.rawValue + "/"
        //https://api.pokemontcg.io/v2/cards/
        dump(urlString)
        let url = URL(string: urlString)!
        return url
    }
}

