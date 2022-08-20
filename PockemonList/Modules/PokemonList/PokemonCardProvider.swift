//
//  PokemonCardProvider.swift
//  PockemonList
//
//  Created by ivan.dekhtiarov on 19/08/2022.
//

import Foundation

protocol PokemonCardProvider {
    
    func getPokemonCards(with completion: @escaping (Result<[PokemonCardListModel], Error>) -> Void)
    func getFavouritePokemonCards(with completion: @escaping (Result<[PokemonCardListModel], Error>) -> Void)
    func setFaouritePokemonCard(model: PokemonCardListModel, with completion: @escaping (Result<PokemonCardListModel, Error>) -> Void)
}

class PokemonCardProviderImpl: PokemonCardProvider {
    
    // MARK: - Dependencies
    
    private let apiManager: PokemonCardAPIManager
    private let userDefaults: UserDefaults
    
    // MARK: - Dependencies
    
    static let storageFavouritePokemonCardsKey = "favourite_pokemon_cards"
    
    // MARK: - Inititalizer
    
    init(
        apiManager: PokemonCardAPIManager,
        userDefaults: UserDefaults
    ) {
        self.apiManager = apiManager
        self.userDefaults = userDefaults
    }
    
    // MARK: - PokemonCardProvider
    
    func getPokemonCards(
        with completion: @escaping (Result<[PokemonCardListModel], Error>) -> Void
    ) {
        apiManager.getPokemonCards { result in
            let newResult = result.map { cards in
                cards.map { card in
                    PokemonCardListModel(pokemon: card, favorite: false)
                }
            }
            completion(newResult)
        }
    }
    
    func getFavouritePokemonCards(
        with completion: @escaping (Result<[PokemonCardListModel], Error>) -> Void
    ) {
        apiManager.getPokemonCards { [weak self] result in
            let favourites = self?.getFauritePokemonCardsFlags() ?? [:]
            let newResult = result.map { cards in
                cards
                    .filter { favourites[$0.id] ?? false }
                    .map { card in
                        PokemonCardListModel(pokemon: card, favorite: false)
                    }
            }
            completion(newResult)
        }
    }
    
    func setFaouritePokemonCard(
        model: PokemonCardListModel,
        with completion: @escaping (Result<PokemonCardListModel, Error>) -> Void
    ) {
        var newModel = model
        newModel.favorite.toggle()
        
        var favourites = getFauritePokemonCardsFlags()
        favourites[model.pokemon.id] = newModel.favorite
        saveFauritePokemonCardsFlags(favourites)
        completion(.success(newModel))
    }
    
    // MARK: - Local Storage
    
    private func getFauritePokemonCardsFlags() -> [String:Bool] {
        guard let favouritePokemonFlags = userDefaults.dictionary(
            forKey: PokemonCardProviderImpl.storageFavouritePokemonCardsKey
        ) as? [String:Bool] else {
            return [:]
        }
        return favouritePokemonFlags
    }
    
    private func saveFauritePokemonCardsFlags(_ flags: [String:Bool]) ->Void {
        userDefaults.set(
            flags,
            forKey: PokemonCardProviderImpl.storageFavouritePokemonCardsKey
        )
    }
}
