//
//  PokemonCardProvider.swift
//  PockemonList
//
//  Created by ivan.dekhtiarov on 19/08/2022.
//

import Foundation

protocol PokemonCardProvider {
    
    func getPokemonCards(completion: @escaping (Result<[PokemonCardListModel], Error>) -> Void)
    func getFavouritePokemonCards(completion: @escaping (Result<[PokemonCardListModel], Error>) -> Void)
    func setFaouritePokemonCard(model: PokemonCardListModel, completion: @escaping (Result<PokemonCardListModel, Error>) -> Void)
}

class PokemonCardProviderImpl: PokemonCardProvider {
    
    // MARK: - Dependencies
    
    private let apiManager: PokemonCardAPIManager
    private let userDefaults: UserDefaults
    
    // MARK: - Constants
    
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
        completion: @escaping (Result<[PokemonCardListModel], Error>) -> Void
    ) {
        apiManager.getPokemonCards { [weak self] result in
            let favourites = self?.favouritePokemonCardsFlags ?? [:]
            let newResult = result.map { cards in
                cards.map { card in
                    PokemonCardListModel(
                        pokemon: card,
                        favourite: favourites[card.id] ?? false
                    )
                }
            }
            completion(newResult)
        }
    }
    
    func getFavouritePokemonCards(
        completion: @escaping (Result<[PokemonCardListModel], Error>) -> Void
    ) {
        apiManager.getPokemonCards { [weak self] result in
            let favourites = self?.favouritePokemonCardsFlags ?? [:]
            let newResult = result.map { cards in
                cards
                    .compactMap { card -> PokemonCardListModel? in
                        guard favourites[card.id] ?? false else {
                            return nil
                        }
                        return PokemonCardListModel(
                            pokemon: card,
                            favourite: true
                        )
                    }
            }
            completion(newResult)
        }
    }
    
    func setFaouritePokemonCard(
        model: PokemonCardListModel,
        completion: @escaping (Result<PokemonCardListModel, Error>) -> Void
    ) {
        var newModel = model
        newModel.favourite.toggle()
        favouritePokemonCardsFlags[model.pokemon.id] = newModel.favourite
        completion(.success(newModel))
    }
    
    // MARK: - Local Storage

    @Storage(
        key: PokemonCardProviderImpl.storageFavouritePokemonCardsKey,
        defaultValue: [:],
        userDefaults: .standard
    )
    var favouritePokemonCardsFlags: [String:Bool]
    
}
