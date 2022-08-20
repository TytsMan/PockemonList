//
//  PokemonCardAPIManager.swift
//  PockemonList
//
//  Created by ivan.dekhtiarov on 19/08/2022.
//

import Foundation

class PokemonCardAPIManager {
    
    static let shared = PokemonCardAPIManager()
    
    private init() { }
    
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
    
    func getPokemonCards(with completionHandler: @escaping (Result<[PokemonCard], Error>)->Void) {
        let url = getUrl(endPoint: .cards)
        APIManager.shared.fetchItems(url: url, completion: completionHandler)
    }
    
    private func getUrl(for internetProtocol: InternetProtocol = .https, engineVersion: EngineVersion = .v2, endPoint: EndPoint) -> URL {
        let urlString = internetProtocol.rawValue +
                        PokemonCardAPIManager.domain +
                        engineVersion.rawValue +
                        endPoint.rawValue
        let url = URL(string: urlString)!
        return url
    }
}

