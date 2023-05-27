//
//  Presenter.swift
//  CDW-MemoryMatchCardGame
//
//  Created by Ikmal Azman on 27/05/2023.
//

import Foundation

protocol PresenterDelegate : AnyObject {
    func didCardMatches(_ firstFlippedCardIndex : IndexPath, _ secondFlippedCardIndex : IndexPath, _ isCardMatches :Bool)
    func didSelectCard(_ indexPath : IndexPath)
    func didTimerElapsed(_ title : String)
    func didTimeFinished()
    func didGameEnd(_ isUserWon : Bool)
}

final class Presenter {
    
    var model = CardModel()
    var cardArray = [Card]()
    var matchedCard = [Card]()
    
    /// Track if the first card already been flipped. If empty it is a first card, else second card.
    var firstFlippedCardIndex : IndexPath?
    var timer : Timer?
    /// Time give for user to complete the puzzle
    /// 10 seconds
    var miliseconds : Float = 10 * 1000
    
    var isThereAnyTimeLeft : Bool {
        return miliseconds > 0
    }
    
    /// Convert miliseconds into seconds and limit the decimal to 2 decimal places
    var secondsPretty : String {
        let seconds = String(format: "%.2f", miliseconds/1000)
        return seconds
    }
    
    weak var delegate : PresenterDelegate?
    
    func getCards() {
        SoundManager.playSound(.shuffle)
        
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
        
        delegate?.didTimerElapsed(secondsPretty)
        
        // Stop timer when it reach 0 miliseconds
        if miliseconds <= 0 {
            timer?.invalidate()
            
            delegate?.didTimeFinished()
            
            // Check if there's other card unmatched
            checkedGameEnded()
        }
    }
    
    func selectCards(atIndexPath indexPath: IndexPath) {
        let selectedCard = cardArray[indexPath.row]
        
        // Flip or UnFlip the card
        if selectedCard.isFlipped == false && selectedCard.isMatched == false {
            SoundManager.playSound(.flip)
            
            delegate?.didSelectCard(indexPath)
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
    
    func checkForMatches(_ secondFlippedCardIndex : IndexPath) {
        guard let firstFlippedCardIndex = firstFlippedCardIndex else {
            fatalError("First Flipped Card Index is Empty")
        }
        
        // Get the two cards object being revealed
        let cardOne = cardArray[firstFlippedCardIndex.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        // Compare two cards
        let cardMatchStatus = cardOne.cardName == cardTwo.cardName
        
        if cardMatchStatus {
            // Cards Matched
            
            // Set status of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // Store matches card into array
            matchedCard.append(cardOne)
            delegate?.didCardMatches(firstFlippedCardIndex, secondFlippedCardIndex, cardMatchStatus)
            
            SoundManager.playSound(.match)
            
            // Check if there's any card left unmatched
            checkedGameEnded()
        } else {
            // Cards not Matched
            
            // Set status of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            delegate?.didCardMatches(firstFlippedCardIndex, secondFlippedCardIndex, cardMatchStatus)
            
            SoundManager.playSound(.noMatch)
        }
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
            
            delegate?.didGameEnd(isUserWon)
        } else {
            // Return if there's any time left
            if isThereAnyTimeLeft {
                return
            }
            
            delegate?.didGameEnd(isUserWon)
        }
    }
}
