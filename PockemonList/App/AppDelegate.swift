//
//  AppDelegate.swift
//  PockemonList
//
//  Created by ivan.dekhtiarov on 19/08/2022.
//

import Foundation
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let vc = PokemonVCFactroy.shared
            .createPokemonCardVC()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }

}

class PokemonVCFactroy {
    
    static let shared = PokemonVCFactroy()
    
    private lazy var networkService = NetworkServiceImpl()
    private lazy var apiManager = PokemonCardAPIManagerImpl(
        networkService: networkService
    )
    private lazy var provider = PokemonCardProviderImpl(
        apiManager: apiManager,
        userDefaults: UserDefaults.standard
    )
    
    func createPokemonCardVC() -> UIViewController {
        
        
        guard let navController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? UINavigationController,
              let vc = navController.topViewController as? PokemonCardListViewController else {
            fatalError()
        }
        
        vc.pokemonCardProvider = provider
        
        return navController
    }
    
    func createPokemonCardDetailVC(with model: PokemonCardListModel) -> UIViewController {
        
        let vc = PokemonDetailViewController(
            pokemonCardProvider: provider,
            model: model)
        return vc
    }
}
