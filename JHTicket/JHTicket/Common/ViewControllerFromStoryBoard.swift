//
//  ViewControllerFromStoryBoard.swift
//  JHTicket
//
//  Created by JH on 2021/09/03.
//

import UIKit

protocol ViewControllerFromStoryBoard { }

extension ViewControllerFromStoryBoard where Self: UIViewController {
    static func viewController(from storyboardName: String) -> Self {
        guard let viewController: Self = UIStoryboard(name: storyboardName, bundle: nil)
            .instantiateViewController(withIdentifier: String(describing: Self.self)) as? Self else { return Self() }
        return viewController
    }
}
