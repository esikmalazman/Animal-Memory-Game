//
//  CardCollectionViewCell.swift
//  CDW-MemoryMatchCardGame
//
//  Created by Ikmal Azman on 20/05/2023.
//

import UIKit

final class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView : UIImageView!
    @IBOutlet weak var backImageView : UIImageView!
    
    static let identifier : String = "CardCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: CardCollectionViewCell.identifier, bundle: .main)
    }
    
}
