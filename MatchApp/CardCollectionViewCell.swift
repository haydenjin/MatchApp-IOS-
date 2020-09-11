//
//  CardCollectionViewCell.swift
//  MatchApp
//
//  Created by Hayden jin on 2020-07-06.
//  Copyright © 2020 Hayden jin. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var FrontImageView: UIImageView!
    
    
    
    @IBOutlet weak var BackImageView: UIImageView!
    
    var card:Card?
    
    func configureCell(card:Card) {
        
        // keep track of the card that this variable represents
        self.card = card
        
        // set front image view to image thats supposed to be on the card
        FrontImageView.image = UIImage(named: card.imageName)
        
        if card.isMattched == true {
            
            BackImageView.alpha = 0
            FrontImageView.alpha = 0
        }
        else {
            
            BackImageView.alpha = 1
            FrontImageView.alpha = 1
        }
        
        // Reset the state of the cell by checking the fipped the status of the card then show the front or back accordingly
        if card.isFlipped == true {
            
            //Show the front image view
            flipUp(speed: 0)
        }
        else {
            
            flipDown(speed: 0, delay: 0)
        }
        
    }
    
    func flipUp(speed:TimeInterval = 0.3) {
        
        UIView.transition(from: BackImageView, to: FrontImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft] , completion: nil)
        
        // Set the status of the card
        card?.isFlipped = true
    }
    
    func flipDown(speed:TimeInterval = 0.3, delay:TimeInterval = 0.5) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            
            UIView.transition(from: self.FrontImageView, to: self.BackImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft] , completion: nil)
        }
        
        // Set the status of the card
        card?.isFlipped = false
    }
    
    func remove() {
        
        // Make the images invisible
        BackImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            
            self.FrontImageView.alpha = 0
            
        }, completion: nil)
    }
}
