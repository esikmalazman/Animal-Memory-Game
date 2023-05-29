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

    @IBOutlet weak var scoreCardImageView: UIImageView!
    @IBOutlet weak var scoreCardLabel: UILabel!
    @IBOutlet weak var virtualAnimalBtn: UIButton!
    @IBOutlet weak var speakerBtn: UIButton!
    
    static let identifier : String = "ScoreCardCell"
    static func nib() -> UINib {
        UINib(nibName: ScoreCardCell.identifier, bundle: .main)
    }
    
    weak var delegate : ScoreCardCellDelegate?
    private(set) var card : Card?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        scoreCardImageView.layer.cornerRadius = 5
        virtualAnimalBtn.layer.cornerRadius = 5
        speakerBtn.layer.cornerRadius = 15
    }
    
    func configureScoreCard(_ card : Card) {
        self.card = card
        self.scoreCardLabel.text = card.cardLabel
        self.scoreCardImageView.image = UIImage(named: "\(card.cardName)Background")
    }

    @IBAction func speakerTapped(_ sender: UIButton) {
        if let card = card {
            delegate?.didSelectPlaySound(card)
        }
    }
    @IBAction func virtualAnimalTapped(_ sender: UIButton) {
        if let card = card {
            delegate?.didSelectVirtualAnimal(card)
        }
    }
}
