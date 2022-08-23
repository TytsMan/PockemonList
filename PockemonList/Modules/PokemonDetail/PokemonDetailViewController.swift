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
    
    lazy var favouriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "star"),
            style: .plain,
            target: self,
            action: #selector(favouritesButtonTapped))
        return button
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    let coverView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var supertypeLabel: UILabel = { [unowned self] in createLabel() }()
    private lazy var levelLabel: UILabel = { [unowned self] in createLabel() }()
    private lazy var hpLabel: UILabel = { [unowned self] in createLabel() }()
    private lazy var evolvesFromLabel: UILabel = { [unowned self] in createLabel() }()
    private lazy var evolvesToLabel: UILabel = { [unowned self] in createLabel() }()
    private lazy var abilitiesLabel: UILabel = { [unowned self] in createLabel() }()
    private lazy var attacksLabel: UILabel = { [unowned self] in createLabel() }()
    private lazy var weaknessesLabel: UILabel = { [unowned self] in createLabel() }()
    private lazy var resistancesLabel: UILabel = { [unowned self] in createLabel() }()
    private lazy var rarityLabel: UILabel = { [unowned self] in createLabel() }()
    private lazy var artistLabel: UILabel = { [unowned self] in createLabel() }()
    private lazy var descriptionLabel: UILabel = { [unowned self] in createLabel() }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUIElement(with: model)
        setupConstrains()
        updateUI()
    }
    
    // MARK: - Setup
    
    private func setupUIElement(with model: PokemonCardListModel) -> Void {
        // do stuff
        
        view.backgroundColor = .white
        
        title = model.pokemon.name
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = favouriteButton
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        let stackViews: [UIView] = [
            coverView,
            supertypeLabel,
            levelLabel,
            hpLabel,
            evolvesFromLabel,
            evolvesToLabel,
            abilitiesLabel,
            attacksLabel,
            weaknessesLabel,
            resistancesLabel,
            rarityLabel,
            artistLabel,
            descriptionLabel
        ]
        stackViews.forEach { stackView.addArrangedSubview($0) }
        
        let pockemonImageUrl = URL(string: model.pokemon.images.small)
        coverView.sd_setImage(with: pockemonImageUrl)
        
        supertypeLabel.text = "Supertype: \(model.pokemon.supertype.rawValue)"
        levelLabel.text = "Level: \(model.pokemon.level ?? "??")"
        hpLabel.text = "HP: \(model.pokemon.hp)"
        evolvesFromLabel.text = "Evolves from: \(model.pokemon.evolvesFrom ?? "??")"
        evolvesToLabel.text = "Evolves to: \(model.pokemon.evolvesTo?.joined(separator: ", ") ?? "??")"
        abilitiesLabel.text = "Abilities: \(model.pokemon.abilities?.map { $0.name }.joined(separator: ", ") ?? "??")"
        attacksLabel.text = "Attacks: \(model.pokemon.attacks?.map { $0.name }.joined(separator: ", ") ?? "??")"
        weaknessesLabel.text = "Weaknesses: \(model.pokemon.weaknesses?.map { $0.type.rawValue }.joined(separator: ", ") ?? "??")"
        resistancesLabel.text = "Resistances: \(model.pokemon.resistances?.map { $0.type.rawValue }.joined(separator: ", ") ?? "??")"
        rarityLabel.text = "Level: \(model.pokemon.rarity?.rawValue ?? "??")"
        artistLabel.text = "Level: \(model.pokemon.artist)"
        descriptionLabel.text = "Level: \(model.pokemon.flavorText ?? "??")"
    }
    
    func setupConstrains() {
        scrollView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }
    
    func updateUI() {
        favouriteButton.image = model.favourite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    }
    
    // MARK: - Logic
    
    func toggleFavouriteFlag() {
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
