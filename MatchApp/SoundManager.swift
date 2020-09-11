//
//  SoundManager.swift
//  MatchApp
//
//  Created by Hayden jin on 2020-07-08.
//  Copyright © 2020 Hayden jin. All rights reserved.
//

import Foundation
import AVFoundation

// Class to keep track of and play all sounds
class SoundManager {
    
    // Empty variable of AVAudio type
    var audioPlayer:AVAudioPlayer?
    
    // Creating some enum variables which can be used instead of the file names
    enum SoundEffect {
        
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    // Function to play a certain sound
    func playSound(effect:SoundEffect) {
        
        var soundFileName = ""
        
        switch effect {
            
            case .flip:
                soundFileName = "cardflip"
                
            case .match:
                soundFileName = "dingcorrect"
                
            case .nomatch:
                soundFileName = "dingwrong"
                
            case .shuffle:
                soundFileName = "shuffle"
        }
        
        // Getting path to file sounds
        let bundelPath = Bundle.main.path(forResource: soundFileName, ofType: ".wav")
        
        // Check if its nil
        guard bundelPath != nil else {
            return
        }
        
        let url = URL(fileURLWithPath: bundelPath!)
        
        // Error handling
        do {
            // Trying to do this but may get an error, if there is an error, the catch statement kicks in
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            audioPlayer?.play()
        }
        catch {
            print("Couldn't create an audio player")
            return
        }
    }
}
