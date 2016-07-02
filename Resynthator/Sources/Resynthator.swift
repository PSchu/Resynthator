//
//  Resynthator.swift
//  Resynthator
//
//  Created by Peter Schumacher on 22.06.16.
//
//

import Foundation
import AVFoundation


public class Resynthator {
    let synthesizer = AVSpeechSynthesizer()
    let paragraphs: [String]
    
    init(paragraph: String) {
        paragraphs = [paragraph]
    }
    
    init(paragraphs: [String]) {
        self.paragraphs = paragraphs
    }
    
    func recitade() -> Self {
        let utterances = paragraphs.map(AVSpeechUtterance.init)
        utterances.forEach(synthesizer.speakUtterance)
        return self
    }
}

public extension String {
    func recitade() -> Resynthator {
        return Resynthator(paragraph: self).recitade()
    }
}

public extension CollectionType where Generator.Element == String {
    func recitade() -> Resynthator {
        return Resynthator(paragraphs: Array(self)).recitade()
    }
}
