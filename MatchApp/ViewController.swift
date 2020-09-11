//
//  ViewController.swift
//  MatchApp
//
//  Created by Hayden jin on 2020-07-06.
//  Copyright © 2020 Hayden jin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Controls the collection view (user input)
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Connection to timer label in story board
    @IBOutlet weak var timerLabel: UILabel!
    
    // Creating an optional empty timer variable
    var timer:Timer?
    
    var millisec:Int = 100 * 1000 // 10 thousand
    
    let model = CardModel()
    var cardsArray = [Card]()
    var firstFlippedCardIndex:IndexPath?
    
    // A variable of the soundmanager class
    var soundPlayer = SoundManager()

    // When objects and images are loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cardsArray = model.getcards()
        
        // Set the viewcontroller as the datasource and and the delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Inital the timer
        timer = Timer.scheduledTimer(timeInterval: 1/1000, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        
        // Adding the timer to the secondary loop so it doesn't pause when it's scrolling
        RunLoop.main.add(timer!, forMode: .common)
        
    }
    
    // When objects and images start showing up on the screen
    override func viewDidAppear(_ animated: Bool) {
        
        // Play shuffle sound
        soundPlayer.playSound(effect: .shuffle)
    }
    
    // MARK: - Timer Methods
    
    @objc func timerFired() {
        
        // Decrement the counter
        millisec -= 1
        
        // Update the label
        let seconds:Double = Double(millisec)/1000.0
        timerLabel.text = String(format: "Time Remaining %.2f", seconds)
        timerLabel.textColor = UIColor.black
        
        // Stop timer if it gets to zero
        if millisec == 0 {
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
        // Check if user won
        checkForGameEnd()
            
        }
        

    }
    
    
    //MARK: - Collection view delegate Methods
    
    // How many items to display
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Returning the number of cards (AKA how many to display)
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a cell and make sure it knows to return a CardCollectionViewCell to us
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Configure the state of the cell based on the properties of the card that it represents
        
        let cardCell = cell as? CardCollectionViewCell
        // Get the card from the card array and configure the cell
        cardCell?.configureCell(card: cardsArray[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Check if there's any time left, if not don't let user interact
        if millisec <= 0 {
            return
        }
        
        // Get reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        // Check status of card to determine how to flip it
        if cell?.card?.isFlipped == false && cell?.card?.isMattched == false{
            
            cell?.flipUp()
            
            // Play shuffle sound
            soundPlayer.playSound(effect: .flip)
            
            // Check if the first card or the second
            if firstFlippedCardIndex == nil {
                
                firstFlippedCardIndex = indexPath
            }
            else {
                
                checkForMatch(indexPath)
            }
        }
        
    }
    
    // MARK: - Game Logic methods
    
    func checkForMatch(_ secondFlippedCardIndex:IndexPath) {
        
        // Get 2 card objects and see if they match
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // Compare the two
        if cardOne.imageName == cardTwo.imageName {
            
            // Play shuffle sound
            soundPlayer.playSound(effect: .match)
            
            // set the status and remove them
            cardOne.isMattched = true
            cardTwo.isMattched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            checkForGameEnd()
        }
        else {
            
            // Play shuffle sound
            soundPlayer.playSound(effect: .nomatch)
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip them back around
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
        }
        
        // Reset the firstFlippedCardIndex
        firstFlippedCardIndex = nil
    }
    
    func checkForGameEnd() {
        
        // Check if all pairs are matched
        
        // Assume user has won, check all the cards, if even one card isnt matched change it to false
        var hasWon = true
        
        for card in cardsArray {
            if card.isMattched == false {
                
                // Found an unmatched card
                hasWon = false
                break
            }
        }
        
        if hasWon == true {
            
            // User has won
            showAlert(title: "Congratulations!", message: "You have won the game")
        }
        else {
            
            // User hasn't won, check if time left
            if millisec <= 0 {
                
                showAlert(title: "Times up", message: "Better luck next time")
            }
        }
        
    }
    
    func showAlert(title:String, message:String) {
        
        // Creating the alert to be shown
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Creating the action for the alert
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        // Adding the action to the alert
        alert.addAction(okAction)
        
        // Shows the alert
        present(alert, animated: true, completion: nil)
    }
}
