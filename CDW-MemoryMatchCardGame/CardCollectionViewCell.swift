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
    
    var card : Card?
    
    static let identifier : String = "CardCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: CardCollectionViewCell.identifier, bundle: .main)
    }
    
    func setCard(_ card : Card) {
        self.card = card
        
        frontImageView.image = UIImage(named: card.cardName)
        
        // Validate the card the displayed in correct state when cell get reused
        validateCardState(card)
    }
    
    func flip() {
        // Flip card from left to right
        // Hide the view that get transition, otherwise it will get remove
        UIView.transition(
            from: backImageView,
            to: frontImageView,
            duration: 0.3,
            options: [.transitionFlipFromLeft, .showHideTransitionViews])
    }
    
    func flippedBack() {
        UIView.transition(
            from: frontImageView,
            to: backImageView,
            duration: 0.3,
            options: [.transitionFlipFromRight, .showHideTransitionViews])
    }
}
private extension CardCollectionViewCell {
    func validateCardState(_ card : Card) {
        
        if card.isFlipped {
            // Make sure front image in on top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews])
        } else {
            // Make sure back image in on top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews])
        }
    }
}
