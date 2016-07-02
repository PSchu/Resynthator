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
    
    func stop() -> Self {
        //Stop Reading
        return self
    }
    
    func resume() -> Self {
        //Resume Reading
        return self
    }
    
    func next() -> Self {
        //jump to next Paragraph
        return self
    }
    
    func back() -> Self {
        //repeat current Paragraph or jump to last Paragraph if only not more the 2 seconds where spoken and not first Paragraph
        return self
    }
    
    func `repeat`() -> Self {
        //Repeat current Paragraph
        return self
    }
}

public extension String {
    func recitade() -> Resynthator {
        return Resynthator(paragraph: self).recitade()
    }
}

public extension SequenceType where Generator.Element == String {
    func recitade() -> Resynthator {
        return Resynthator(paragraphs: Array(self)).recitade()
    }
}
