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
4. OPTIONAL : Specifically do for endangered animals otherwise general animal would do
""")

final class ViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    /// Track if the first card already been flipped. If empty it is a first card, else second card.
    var firstFlippedCardIndex : IndexPath?
    var timer : Timer?
    /// Time give for user to complete the puzzle
    /// 10 seconds
    var miliseconds : Float = 10 * 1000
    
    var isThereAnyTimeLeft : Bool {
        return miliseconds > 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SoundManager.playSound(.shuffle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        cardArray = model.getCards()
        // Create timer with time interval of miliseconds, it is seconds by default
        timer = Timer.scheduledTimer(timeInterval: 0.001,
                                     target: self,
                                     selector: #selector(timeElapsed),
                                     userInfo: nil,
                                     repeats: true)
        // Make the timer run even the user scroll or not, so timer not stop. By default, it will stop because it is on default RunLoop mode
        RunLoop.main.add(timer!, forMode: .tracking)
    }
    
    // Method will active everytime timer elapse from 1 miliseconds
    @objc
    func timeElapsed() {
        // Deduct 1 seconds when method active
        miliseconds = miliseconds - 1
        
        // Convert miliseconds into seconds and limit the decimal to 2 decimal places
        let seconds = String(format: "%.2f", miliseconds/1000)
        
        timerLabel.text = "Time Remaining : \(seconds)"
        
        // Stop timer when it reach 0 miliseconds
        if miliseconds <= 0 {
            timer?.invalidate()
            timerLabel.textColor = .red
            collectionView.isUserInteractionEnabled = false
            
            // Check if there's other card unmatched
            checkedGameEnded()
        }
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
            SoundManager.playSound(.flip)
            
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
            
            SoundManager.playSound(.match)
            
            // Check if there's any card left unmatched
            checkedGameEnded()
        } else {
            // Cards not Matched
            
            // Set status of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip back both cards
            cardOneCell?.flippedBack()
            cardTwoCell?.flippedBack()
            
            SoundManager.playSound(.noMatch)
        }
        
        // Tell collectionView to reload cell of first card if its index empty
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex])
        }
        
        // Reset the first card index and allow the matching logic start over again
        self.firstFlippedCardIndex = nil
    }
    
    func checkedGameEnded(){
        // Check if there any card unmatched
        var isUserWon : Bool = true
        
        // If not , user's won and stop timer
        /// Iterate item in the array to see if there any umatched card, if there any stop the loop
        for card in cardArray {
            if card.isMatched == false {
                isUserWon = false
                break
            }
        }
        
        // If there any unmatched card, check time any left
        if isUserWon {
            if isThereAnyTimeLeft {
                timer?.invalidate()
            }
            
            // Show Won Messages Alert
            showAlert(title: "Congratulations", message: "You have Won")
        } else {
            // Return if there's any time left
            if isThereAnyTimeLeft {
                return
            }
            
            // Show Lost Messages Alert
            showAlert(title: "Game Over", message:  "You have lost")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
}
