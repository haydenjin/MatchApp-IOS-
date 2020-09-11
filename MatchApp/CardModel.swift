//
//  CardModel.swift
//  MatchApp
//
//  Created by Hayden jin on 2020-07-06.
//  Copyright © 2020 Hayden jin. All rights reserved.
//

import Foundation


class CardModel {
    func getcards() -> [Card] {
        
        // Have an empty array to store numbers that have already been generated
        var generatedNumbers = [Int]()
        
        var generatedCards = [Card]()
        
        // Creating 8 pairs of cards
        while generatedNumbers.count < 8 {
            
            // variable that generates random numbers
            let randomNumber = Int.random(in: 1...13)
            
            // If the generated number isn't in the array, generate the cards and add the number to the array
            if generatedNumbers.contains(randomNumber) == false {
                
                let cardOne = Card()
                let cardTwo = Card()
                
                cardOne.imageName = "card\(randomNumber)"
                cardTwo.imageName = "card\(randomNumber)"
                
                generatedCards += [cardOne, cardTwo]
                
                // Adding the generated number to the array
                generatedNumbers += [randomNumber]
                
                print(randomNumber)
            }
        }
        
        generatedCards.shuffle()
        
        return generatedCards
    }
}
