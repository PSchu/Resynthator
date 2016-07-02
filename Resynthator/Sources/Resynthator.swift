//
//  Resynthator.swift
//  Resynthator
//
//  Created by Peter Schumacher on 22.06.16.
//
//

import Foundation
import AVFoundation

class Resynthator {
    let synthesizer = AVSpeechSynthesizer()
    
    static let instance = Resynthator()
    
    func recitade(string: String) {
        let utterance = AVSpeechUtterance(string: string)
        synthesizer.speakUtterance(utterance)
    }
}

public extension String {
    func recitade() {
        Resynthator.instance.recitade(self)
    }
}