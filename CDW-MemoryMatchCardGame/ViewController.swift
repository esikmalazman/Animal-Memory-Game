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
        if selectedCard.isFlipped == false {
            selectedCell.flip()
            selectedCard.isFlipped = true
        } else {
            selectedCell.flippedBack()
            selectedCard.isFlipped = false
        }
    }
}
