//
//  PokemonCardListViewController.swift
//  PockemonList
//
//  Created by ivan.dekhtiarov on 19/08/2022.
//

import UIKit

enum PokemonListState {
    case loading
    case list([PokemonCardListModel])
    case favourites([PokemonCardListModel])
    case error(Error)
}

class PokemonCardListViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var favouritesButton: UIBarButtonItem!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Dependencies
    
    let pokemonCardProvider: PokemonCardProvider! = nil
    
    // MARK: - Properties
    
    private var state: PokemonListState = .loading {
        didSet {
            handleState(state)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIElements()
        
        pokemonCardProvider.getPokemonCards { [weak self] result in
            switch result {
            case .failure(let error):
                self?.state = .error(error)
            case .success(let cards):
                self?.state = .list(cards)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // do some stuff
    }
    
    // MARK: - Setup
    
    private func setupUIElements() {
        
        title = "Pokémon Cards"
    }
    
    // MARK: - Logic
    
    private func handleState(_ state: PokemonListState) -> Void {
        switch state {
        case .loading:
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            
        case .list:
            activityIndicatorView.stopAnimating()
            favouritesButton.image = UIImage(named: "star")
            
        case .favourites:
            activityIndicatorView.stopAnimating()
            favouritesButton.image = UIImage(named: "star.fill")
            
        case .error(let error):
            activityIndicatorView.stopAnimating()
            showAlert(with: error) { [weak self] in
                self?.state = .list([])
            }
        }
        tableView.reloadData()
    }
    
    // seems i can't use this method since i should to pass destinationState property
    private func handleNetworkResponce(
        result: Result<[PokemonCardListModel], Error>,
        // here i can use wrapper for states(.list, .favourites)
        for destationState: PokemonListState
    ) -> Void {
        switch result {
        case .failure(let error):
            state = .error(error)
            
        case .success(let cards):
            switch destationState {
            case .list(_):
                state = .list(cards)
            case .favourites(_):
                state = .favourites(cards)
            case .loading, .error(_):
                break
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func favouritesButtonTapped(_ sender: Any) {
        
        switch state {
        case .list:
            state = .loading
            pokemonCardProvider.getFavouritePokemonCards { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.state = .error(error)
                case .success(let cards):
                    self?.state = .favourites(cards)
                }
            }
        case .favourites:
            state = .loading
            pokemonCardProvider.getPokemonCards { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.state = .error(error)
                case .success(let cards):
                    self?.state = .list(cards)
                }
            }
        case .loading, .error(_):
            break
        }
    }
    
    func favouriteButtonTapped(model: PokemonCardListModel) -> Void {
        pokemonCardProvider.setFaouritePokemonCard(model: model) { [weak self] result in
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
    
    func detailButtonTapped(model: PokemonCardListModel) -> Void {
        let detailVC = PokemonDetailViewController()
        detailVC.model = model
        show(detailVC, sender: self)
    }
    
}

// MARK: - UITableViewDataSource

extension PokemonCardListViewController: UITableViewDataSource {
    
    var dataSource: [PokemonCardListModel]? {
        switch state {
        case .favourites(let models), .list(let models):
            return models
        case .loading, .error(_):
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCardListCell.reuseIdentifier) as? PokemonCardListCell else {
            return UITableViewCell()
        }
        let pokemonCardMode = dataSource![indexPath.row]
        cell.setupUIElements(with: pokemonCardMode)
        return cell
    }
}

// MARK: - UITableViewDelegate
// don't needed since i use closures
extension PokemonCardListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource![indexPath.row]
        let detailVC = PokemonDetailViewController()
        detailVC.model = model
        show(detailVC, sender: self)
    }
}
