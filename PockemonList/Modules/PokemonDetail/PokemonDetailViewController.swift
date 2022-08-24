//
//  PokemonDetailViewController.swift
//  PockemonList
//
//  Created by ivan.dekhtiarov on 19/08/2022.
//

import UIKit
import SnapKit

class PokemonDetailViewController: UIViewController {
    
    // MARK: - Dependencies
    
    private let pokemonCardProvider: PokemonCardProvider
    
    // MARK: - Properties
    
    private var model: PokemonCardListModel
    
    // MARK: - UI Elements
    
    private lazy var favouriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "star"),
            style: .plain,
            target: self,
            action: #selector(favouritesButtonTapped))
        return button
    }()
    
    private lazy var contentView: PokemonDetailView = PokemonDetailView(model: model)
    
    // MARK: - Initiaziler
    
    init(
        pokemonCardProvider: PokemonCardProvider,
        model: PokemonCardListModel
    ) {
        self.pokemonCardProvider = pokemonCardProvider
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unimplemented initializer!")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUIElement(with: model)
        updateUI()
    }
    
    // MARK: - Setup
    
    private func setupUIElement(with model: PokemonCardListModel) -> Void {
        title = model.pokemon.name
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = favouriteButton
    }
    
    private func updateUI() {
        favouriteButton.image = model.favourite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    }
    
    // MARK: - Logic
    
    private func toggleFavouriteFlag() {
        pokemonCardProvider.setFaouritePokemonCard(model: model) { [weak self] result in
            switch result {
            case .success(let model):
                self?.model = model
                self?.updateUI()
            case .failure(let error):
                self?.showAlert(with: error)
            }
        }
    }
    
    // MARK: - Actions
    
    @objc
    func favouritesButtonTapped() {
        toggleFavouriteFlag()
    }
}
