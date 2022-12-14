//
//  PokemonListCell.swift
//  PockemonList
//
//  Created by ivan.dekhtiarov on 19/08/2022.
//

import UIKit
import SDWebImage

class PokemonCardListCell: UITableViewCell {
    
    typealias ActionHandler = (PokemonCardListModel) -> Void
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var pokemonImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var supertypeLabel: UILabel!
    @IBOutlet private weak var evolvesFromLabel: UILabel!
    @IBOutlet private weak var hpLabel: UILabel!
    @IBOutlet private weak var favouriteButton: UIButton!
    @IBOutlet private weak var DetailButton: UIButton!
    
    // MARK: - Properties
    
    var model: PokemonCardListModel?
    
    var favouriteActionHandler: ActionHandler?
    var detailActionHandler: ActionHandler?
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        dump(#function)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        dump(#function)
    }
    
    deinit {
        dump(#function)
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        dump(#function)
    }
    
    // MARK: - Setup
    
    func setupUIElements(with model: PokemonCardListModel) {
        
        dump(#function)
        
        self.model = model
        
        let pockemonImageUrl = URL(string: model.pokemon.images.small)
        pokemonImageView.sd_setImage(with: pockemonImageUrl)
        
        nameLabel.text = model.pokemon.name
        supertypeLabel.text = model.pokemon.supertype.rawValue
        evolvesFromLabel.text = model.pokemon.evolvesFrom
        hpLabel.text = model.pokemon.hp
        favouriteButton.setImage(
            model.favourite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"),
            for: .normal
        )
    }
    
    // MARK: - Actions
    
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        guard let favouriteActionHandler = favouriteActionHandler,
              let model = model else {
            return
        }
        
        favouriteActionHandler(model)
    }
    
    @IBAction func detailButtonTapped(_ sender: UIButton) {
        guard let detailActionHandler = detailActionHandler,
              let model = model else {
            return
        }
        
        detailActionHandler(model)
    }
    
}
