//
//  CellIdentifierable.swift
//  JHTicket
//
//  Created by JH on 2021/09/03.
//

import UIKit

protocol CellIdentifierable { }

extension CellIdentifierable where Self: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: CellIdentifierable { }
