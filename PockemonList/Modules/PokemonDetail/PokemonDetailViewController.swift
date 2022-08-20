//
//  PokemonDetailViewController.swift
//  PockemonList
//
//  Created by ivan.dekhtiarov on 19/08/2022.
//

import UIKit

private let reuseIdentifier = "Cell"

class PokemonDetailViewController: UIViewController {

    
    var model: PokemonCardListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let model = model {
            setupUIElement(with: model)
        }
    }

    private func setupUIElement(with model: PokemonCardListModel) -> Void {
        // do stuff
    }
    
}
