//
//  UIViewController+Alert.swift
//  PockemonList
//
//  Created by ivan.dekhtiarov on 19/08/2022.
//

import UIKit

extension UIViewController {
    func showAlert(with error: Error, completionHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: nil,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style: .default
        ) { _ in
            completionHandler?()
        }
        alert.addAction(okAction)
        show(alert, sender: self)
    }
}
