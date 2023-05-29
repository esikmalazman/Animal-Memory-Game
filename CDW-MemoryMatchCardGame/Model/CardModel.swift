//
//  CardModel.swift
//  CDW-MemoryMatchCardGame
//
//  Created by Ikmal Azman on 20/05/2023.
//

import Foundation

/*
*    Title: How To Build a Match Game
*    Author: Christopher Ching
*    Date: 2019-07-05
*    Code version: 1.0
*    Availability: https://www.youtube.com/watch?v=ymQpuxCGptU&list=PLMRqhzcHGw1YdahNsCLZdSVfNv0stwvdx
*
*/
final class CardModel {
    
    func getCards() -> [Card] {
        // Array to store numbers alread been generated
        var generatedNumbersArray = [Int]()
        
        // Array to store generated cards
        var generatedCardsArray = [Card]()
        
        // Randomly generate pairs of cards, in this case we do 5 pairs so we loop 5 times
        while generatedNumbersArray.count < cardsDataSouce.count {
            // Generate random numbers
            let randomNumbers = Int.random(in: 0...cardsDataSouce.count - 1)
            
            // Make sure generated numbers are not already have. Allow only unique pairs of card generated.
            if generatedNumbersArray.contains(randomNumbers) == false {
                
                generatedNumbersArray.append(randomNumbers)
                print(randomNumbers)
                
                // Create 2 same card object because we need pair of card to match in the game
                var cardOne = Card()
                
                cardOne.cardName = cardsDataSouce[randomNumbers]
                cardOne.cardLabel = cardsDataSouceLabel[randomNumbers]
                generatedCardsArray.append(cardOne)
                
                var cardTwo = Card()
                
                cardTwo.cardName = cardsDataSouce[randomNumbers]
                cardTwo.cardLabel = cardsDataSouceLabel[randomNumbers]
                generatedCardsArray.append(cardTwo)
            }
        }
        
        //  Randomize the array by shuffle the position of elements
        return generatedCardsArray.shuffled()
    }
}

let cardsDataSouce = ["BlueWhale","HawksbillSeaTurtle", "JavaRhinoceros", "LittleBluePenguin", "PolarBear"]
let cardsDataSouceLabel = ["Blue Whale","Hawksbill Sea Turtle", "Java Rhinoceros", "Little Blue Penguin", "Polar Bear"]
