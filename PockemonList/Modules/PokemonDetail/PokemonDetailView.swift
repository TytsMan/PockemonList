//
//  PokemonDetailView.swift
//  PockemonList
//
//  Created by Ivan on 24/08/2022.
//

import UIKit

class PokemonDetailView: UIView {
    
    // MARK: - UI Elements
    
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
    
    private(set) var parameterLabels: [UILabel] = []
    
    // MARK: - Initiaziler
    
    init(model: PokemonCardListModel) {
        
        super.init(frame: .zero)
        
        setupUIElement(with: model)
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unimplemented initializer!")
    }
    
    // MARK: - Setup
    
    private func setupUIElement(with model: PokemonCardListModel) -> Void {
        
        backgroundColor = .white
        
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(coverView)
        
        let parameters = [
            "Supertype: \(model.pokemon.supertype.rawValue)",
            "Level: \(model.pokemon.level ?? "??")",
            "HP: \(model.pokemon.hp)",
            "Evolves from: \(model.pokemon.evolvesFrom ?? "??")",
            "Evolves to: \(model.pokemon.evolvesTo?.joined(separator: ", ") ?? "??")",
            "Abilities: \(model.pokemon.abilities?.map { $0.name }.joined(separator: ", ") ?? "??")",
            "Attacks: \(model.pokemon.attacks?.map { $0.name }.joined(separator: ", ") ?? "??")",
            "Weaknesses: \(model.pokemon.weaknesses?.map { $0.type.rawValue }.joined(separator: ", ") ?? "??")",
            "Resistances: \(model.pokemon.resistances?.map { $0.type.rawValue }.joined(separator: ", ") ?? "??")",
            "Level: \(model.pokemon.rarity?.rawValue ?? "??")",
            "Level: \(model.pokemon.artist)",
            "Level: \(model.pokemon.flavorText ?? "??")"
        ]
        
        parameterLabels = parameters.map(createLabel)
        parameterLabels.forEach { stackView.addArrangedSubview($0) }
        
        let pockemonImageUrl = URL(string: model.pokemon.images.small)
        coverView.sd_setImage(with: pockemonImageUrl)
    }
    
    private func setupConstrains() {
        
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
}

// MARK: - Helper Functions

fileprivate extension PokemonDetailView {
    
    func createLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }
}
 
