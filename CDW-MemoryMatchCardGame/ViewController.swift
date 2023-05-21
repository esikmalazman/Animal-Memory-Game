//
//  ViewController.swift
//  CDW-MemoryMatchCardGame
//
//  Created by Ikmal Azman on 20/05/2023.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    /// Track if the first card already been flipped. If empty it is a first card, else second card.
    var firstFlippedCardIndex : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        cardArray = model.getCards()
    }
}

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as! CardCollectionViewCell
        let card = cardArray[indexPath.row]
        
        cell.setCard(card)
        return cell
    }
}

extension ViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Card on index : \(indexPath.row) selected")
        
        // Get selected cell from collection view
        let selectedCell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        let selectedCard = cardArray[indexPath.row]
        
        // Flip or UnFlip the card
        if selectedCard.isFlipped == false && selectedCard.isMatched == false {
            selectedCell.flip()
            selectedCard.isFlipped = true
            
            // Validate if the first or second card being flipped
            if firstFlippedCardIndex == nil {
                // First card being flipped
                firstFlippedCardIndex = indexPath
            } else {
                // Second card being flipped
                
                // Perform matching logic
                checkForMatches(indexPath)
            }
        }
    }
}

extension ViewController {
    func checkForMatches(_ secondFlippedCardIndex : IndexPath) {
        guard let firstFlippedCardIndex = firstFlippedCardIndex else {
            fatalError("First Flipped Card Index is Empty")
        }
        
        // Get the card cells being revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        
        // Get the two cards object being revealed
        let cardOne = cardArray[firstFlippedCardIndex.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        // Compare two cards
        
        if cardOne.cardName == cardTwo.cardName {
            // Cards Matched
            
            // Set status of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // Remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
        } else {
            // Cards not Matched
            
            // Set status of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip back both cards
            cardOneCell?.flippedBack()
            cardTwoCell?.flippedBack()
            
        }
        
        // Tell collectionView to reload cell of first card if its index empty
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex])
        }
        
        // Reset the first card index and allow the matching logic start over again
        self.firstFlippedCardIndex = nil
    }
}
