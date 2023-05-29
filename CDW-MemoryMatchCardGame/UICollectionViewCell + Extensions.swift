//
//  UICollectionViewCell + Extensions.swift
//  CDW-MemoryMatchCardGame
//
//  Created by Ikmal Azman on 29/05/2023.
//

import UIKit

/*
 *    Title: How to add Different Kinds of Shadows to a UICollectionViewCell (Swift)
 *    Author: Jacob Cavin
 *    Date: 2020-12-31
 *    Code version: 1.0
 *    Availability: https://jacobcavin.medium.com/how-to-add-different-kinds-of-shadows-to-a-uicollectionviewcell-swift-30cc0dcfb626
 *
 */

extension UICollectionViewCell {
    func addShadow(corner: CGFloat = 10, color: UIColor = .black, radius: CGFloat = 15, offset: CGSize = CGSize(width: 0, height: 0), opacity: Float = 0.2) {
        let cell = self
        cell.contentView.layer.borderWidth = 0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = color.cgColor
        cell.layer.shadowOffset = offset
        cell.layer.shadowRadius = radius
        cell.layer.shadowOpacity = opacity
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    }
}

