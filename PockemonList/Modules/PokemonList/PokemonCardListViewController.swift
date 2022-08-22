//
//  PokemonCardListViewController.swift
//  PockemonList
//
//  Created by ivan.dekhtiarov on 19/08/2022.
//

import UIKit

class PokemonCardListViewController: UIViewController {
    
    enum State {
        case loading
        case list([PokemonCardListModel] = [])
        case favourites([PokemonCardListModel] = [])
        case error(Error)
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var favouritesButton: UIBarButtonItem!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Dependencies
    
    var pokemonCardProvider: PokemonCardProvider! = nil
    
    // MARK: - Properties
    
    private var state: State = .list() {
        didSet {
            handleState(state)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIElements()
        
        requestPokemonCardsFor(destinationState: .list())
    }
    
    // MARK: - Setup
    
    private func setupUIElements() {
        
        title = "Pokémon Cards"
        activityIndicatorView.isHidden = true
        activityIndicatorView.hidesWhenStopped = true
    }
    
    // MARK: - Logic
    
    private func handleState(
        _ state: State
    ) -> Void {
        //        dump(state)
        switch state {
        case .loading:
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            
        case .list:
            activityIndicatorView.stopAnimating()
            favouritesButton.image = UIImage(systemName: "star")
            
        case .favourites:
            activityIndicatorView.stopAnimating()
            favouritesButton.image = UIImage(systemName: "star.fill")
            
        case .error(let error):
            activityIndicatorView.stopAnimating()
            showAlert(with: error) { [weak self] in
                self?.state = .list([])
            }
        }
        tableView.reloadData()
    }
    
    private func requestPokemonCardsFor(
        destinationState: State
    ) -> Void {
        state = .loading
        
        let requestHandler: (Result<[PokemonCardListModel], Error>) -> Void = { [weak self] result in
            switch result {
            case .success(let models):
                switch destinationState {
                case .list:
                    self?.state = .list(models)
                case .favourites:
                    self?.state = .favourites(models)
                default:
                    break
                }
            case .failure(let error):
                self?.state = .error(error)
            }
        }
        
        switch destinationState {
        case .list:
            pokemonCardProvider
                .getPokemonCards(completion: requestHandler)
        case .favourites:
            pokemonCardProvider
                .getFavouritePokemonCards(completion: requestHandler)
        default:
            break
        }
        
    }
    
    // MARK: - Actions
    
    @IBAction private func favouritesButtonTapped(
        _ sender: Any
    ) {
        switch state {
        case .list:
            state = .loading
            requestPokemonCardsFor(destinationState: .favourites())
        case .favourites:
            state = .loading
            requestPokemonCardsFor(destinationState: .list())
        default:
            break
        }
    }
    
    private func favouriteButtonTapped(
        model: PokemonCardListModel
    ) -> Void {
        pokemonCardProvider
            .setFaouritePokemonCard(
                model: model
            ) { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.state = .error(error)
                    
                case .success(let model):
                    
                    func updateModels(
                        _ models: inout [PokemonCardListModel],
                        with model: PokemonCardListModel
                    ) -> Void {
                        
                        guard let idx = models.firstIndex(where: { $0.pokemon.id == model.pokemon.id }) else { return }
                        models[idx] = model
                    }
                    
                    switch self?.state {
                    case .list(var models):
                        updateModels(&models, with: model)
                        self?.state = .list(models)
                    case .favourites(var models):
                        updateModels(&models, with: model)
                        self?.state = .favourites(models)
                    case .loading, .error(_), .none:
                        break
                    }
                }
            }
    }
    
    private func detailButtonTapped(
        model: PokemonCardListModel
    ) -> Void {
        let detailVC = PokemonDetailViewController()
        detailVC.model = model
        show(detailVC, sender: self)
    }
    
}

// MARK: - UITableViewDataSource

extension PokemonCardListViewController: UITableViewDataSource {
    
    private var dataSource: [PokemonCardListModel]? {
        switch state {
        case .favourites(let models), .list(let models):
            return models
        case .loading, .error(_):
            return nil
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        dataSource?.count ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCardListCell.reuseIdentifier) as? PokemonCardListCell else {
            return UITableViewCell()
        }
        let pokemonCardMode = dataSource![indexPath.row]
        cell.setupUIElements(with: pokemonCardMode)
        cell.favouriteActionHandler = favouriteButtonTapped
        cell.detailActionHandler = detailButtonTapped
        return cell
    }
}
