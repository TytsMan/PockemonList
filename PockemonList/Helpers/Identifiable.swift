//
//  Identifiable.swift
//  PockemonList
//
//  Created by ivan.dekhtiarov on 19/08/2022.
//

import UIKit

protocol Identifiable {
    static var reuseIdentifier: String { get }
}

extension Identifiable {
    static var reuseIdentifier: String { String(describing: self) }
}

extension UITableViewCell: Identifiable { }
