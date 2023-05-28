//
//  SoundManager.swift
//  CDW-MemoryMatchCardGame
//
//  Created by Ikmal Azman on 21/05/2023.
//

import Foundation
import AVFoundation

enum SoundEffect {
    case flip
    case shuffle
    case match
    case noMatch
}

extension SoundEffect{
    var fileName : String {
        switch self {
        case .flip:
            return "cardflip"
        case .shuffle:
            return "shuffle"
        case .match:
            return "dingcorrect"
        case .noMatch:
            return "dingwrong"
        }
    }
}

final class SoundManager {
    
    static var audioPlayer : AVAudioPlayer?
  static  let syntesizer = AVSpeechSynthesizer()
    
    static func playSound(_ effect : SoundEffect) {
        // Create URL from file path of the sound
        guard let bundleURL = Bundle.main.url(forResource: effect.fileName, withExtension: "wav") else {
            print("Could not find sound file for \(effect.fileName)")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            // Create audio player object and play sound
            audioPlayer = try AVAudioPlayer(contentsOf: bundleURL, fileTypeHint: AVFileType.wav.rawValue)
            
            guard let audioPlayer = audioPlayer else {return}
            
            audioPlayer.play()
        } catch {
            print("Could not play sound for sound file : \(effect.fileName), \(error.localizedDescription)")
        }
    }
    
    static func playTextToSpeech(_ text : String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-IE")
        utterance.rate = 0.2
        utterance.volume = 0.8
        
        syntesizer.speak(utterance)
    }
}
