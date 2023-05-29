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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addShadow(color: UIColor(named: "SecondaryOrange")!, radius: 10, opacity: 1)
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.transition(
                from: self.frontImageView,
                to: self.backImageView,
                duration: 0.3,
                options: [.transitionFlipFromRight, .showHideTransitionViews])
        }
    }
    
    func remove() {
        // Remove both images from visible
        backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut) {
            self.frontImageView.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
        
       
    }
}
private extension CardCollectionViewCell {
    func validateCardState(_ card : Card) {
        // Validate the card to display in correct alpha state
        if card.isMatched {
            frontImageView.alpha = 0
            backImageView.alpha = 0
            return
        } else {
            frontImageView.alpha = 1
            backImageView.alpha = 1
        }
        
        
        // Validate the card to display in correct flip state
        if card.isFlipped {
            // Make sure front image in on top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews])
        } else {
            // Make sure back image in on top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews])
        }
    }
}

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
