//
//  ViewController.swift
//  CDW-MemoryMatchCardGame
//
//  Created by Ikmal Azman on 20/05/2023.
//

import UIKit

final class CardGameViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let presenter = Presenter()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getCards()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        presenter.delegate = self
    }
}

// MARK:  UICollectionViewDataSource
extension CardGameViewController : UICollectionViewDataSource {
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
extension CardGameViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Card on index : \(indexPath.row) selected")
        presenter.selectCards(atIndexPath: indexPath)
    }
}

// MARK:  PresenterDelegate
extension CardGameViewController : PresenterDelegate {
    func didTimerElapsed(_ title: String) {
        timerLabel.text = title
    }
    
    func didTimeFinished() {
        timerLabel.textColor = .red
        collectionView.isUserInteractionEnabled = false
    }
    
    func didGameEnd(_ isUserWon: Bool) {
        if presenter.matchedCard.isEmpty {
            showAlert(title: "Time's Up", message: "Sorry, better luck next time!") {
                self.presenter.getCards()
            } exitAction: {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            /// Show score screen when game ends
            let scoreVC = ScoreViewController()
            scoreVC.configureScore(presenter.matchedCard)
            navigationController?.setNavigationBarHidden(true, animated: true)
            navigationController?.pushViewController(scoreVC, animated: true)
        }
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
    
    func renderCards() {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        collectionView.isUserInteractionEnabled = true
        collectionView.reloadData()
    }
}

// MARK:  Private
private extension CardGameViewController {
    func showAlert(title: String, message: String, retryAction : @escaping ()->Void = {}, exitAction : @escaping ()->Void = {}) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertRetryAction = UIAlertAction(title: "Retry", style: .default) { _ in
            retryAction()
        }
        
        let exitAction = UIAlertAction(title: "Exit", style: .default) { _ in
            exitAction()
        }
        
        alert.addAction(alertRetryAction)
        alert.addAction(exitAction)
        self.present(alert, animated: true)
    }
}
