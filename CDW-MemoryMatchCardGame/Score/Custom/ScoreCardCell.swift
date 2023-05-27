//
//  ScoreCardCell.swift
//  CDW-MemoryMatchCardGame
//
//  Created by Ikmal Azman on 27/05/2023.
//

import UIKit

protocol ScoreCardCellDelegate : AnyObject {
    func didSelectVirtualAnimal(_ card : Card)
    func didSelectPlaySound(_ card : Card)
}

final class ScoreCardCell: UICollectionViewCell {

    static let identifier : String = "ScoreCardCell"
    static func nib() -> UINib {
        UINib(nibName: ScoreCardCell.identifier, bundle: .main)
    }
    
    weak var delegate : ScoreCardCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
    
    func configureScoreCard(_ card : Card) {
        
    }

}
