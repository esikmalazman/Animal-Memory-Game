//
//  CardModel.swift
//  CDW-MemoryMatchCardGame
//
//  Created by Ikmal Azman on 20/05/2023.
//

import Foundation

final class CardModel {
    
    func getCards() -> [Card] {
        // Array to store numbers alread been generated
        var generatedNumbersArray = [Int]()
        
        // Array to store generated cards
        var generatedCardsArray = [Card]()
        
        // Randomly generate pairs of cards, in this case we do 8 pairs so we loop 8 times
        while generatedNumbersArray.count < 8 {
            // Generate random numbers
            let randomNumbers = Int.random(in: 1...13)
            
            // Make sure generated numbers are not already have. Allow only unique pairs of card generated.
            if generatedNumbersArray.contains(randomNumbers) == false {
                
                generatedNumbersArray.append(randomNumbers)
                print(randomNumbers)
                
                // Create 2 same card object because we need pair of card to match in the game
                let cardOne = Card()
                cardOne.cardName = "card\(randomNumbers)"
                generatedCardsArray.append(cardOne)
                
                let cardTwo = Card()
                cardTwo.cardName = "card\(randomNumbers)"
                generatedCardsArray.append(cardTwo)
            }
        }
        
        //  Randomize the array by shuffle the position of elements
        return generatedCardsArray.shuffled()
    }
}
