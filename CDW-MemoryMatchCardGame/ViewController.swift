//
//  ViewController.swift
//  CDW-MemoryMatchCardGame
//
//  Created by Ikmal Azman on 20/05/2023.
//

import UIKit

#warning("""
TODO'S :
1. Show new screen with correct match
2. Allow to play how the animal pronounce
3. OPTIONAL : Allow to view the animal in AR
""")
final class ViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let presenter = Presenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        presenter.getCards()
        presenter.delegate = self
    }
}

// MARK:  UICollectionViewDataSource
extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as! CardCollectionViewCell
        let card = presenter.cardArray[indexPath.row]
        
        cell.setCard(card)
        return cell
    }
}

// MARK:  UICollectionViewDelegate
extension ViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Card on index : \(indexPath.row) selected")
        presenter.selectCards(atIndexPath: indexPath)
    }
}

// MARK:  PresenterDelegate
extension ViewController : PresenterDelegate {
    func didTimerElapsed(_ title: String) {
        timerLabel.text = "Time Remaining : \(title)"
    }
    
    func didTimeFinished() {
        timerLabel.textColor = .red
        collectionView.isUserInteractionEnabled = false
    }
    
    #warning("need to check if no matched card pop up and allow to restart otherwise push to next screen")
    func didGameEnd(_ isUserWon: Bool) {
        /// Show score screen when game ends
        let scoreVC = ScoreViewController()
        scoreVC.configureScore(presenter.matchedCard)
        navigationController?.pushViewController(scoreVC, animated: true)
    }
    
    func didCardMatches(_ firstFlippedCardIndex: IndexPath, _ secondFlippedCardIndex: IndexPath, _ isCardMatches: Bool) {
        // Get the card cells being revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        if isCardMatches {
            // Remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
        } else {
            // Flip back both cards
            cardOneCell?.flippedBack()
            cardTwoCell?.flippedBack()
        }
        
        // Tell collectionView to reload cell of first card if its index empty
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex])
        }
        
        // Reset the first card index and allow the matching logic start over again
        self.presenter.firstFlippedCardIndex = nil
    }
    
    func didSelectCard(_ indexPath: IndexPath) {
        // Get selected cell from collection view
        let selectedCell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        selectedCell.flip()
    }
}

// MARK:  Private
private extension ViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
}
