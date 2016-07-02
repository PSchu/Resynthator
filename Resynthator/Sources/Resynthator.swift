//
//  Resynthator.swift
//  Resynthator
//
//  Created by Peter Schumacher on 22.06.16.
//
//

import Foundation
import AVFoundation

enum SynthesizerState {
    case Playing
    case Paused
    case Stopped
    
    func enforceState(on synthesizer: AVSpeechSynthesizer) {
        switch self {
        case .Playing:
            break
        case .Paused:
            print("enforced")
            synthesizer.pauseSpeakingAtBoundary(.Immediate)
        case .Stopped:
            print("enforced")
            synthesizer.stopSpeakingAtBoundary(.Immediate)
        }
    }
}

public class Resynthator: NSObject {
    private let synthesizer: AVSpeechSynthesizer
    private var synthesizerState = SynthesizerState.Stopped
    
    let paragraphs: [String]
    
    convenience init(paragraph: String) {
        self.init(paragraphs: [paragraph])
    }
    
    init(paragraphs: [String]) {
        self.synthesizer = AVSpeechSynthesizer()
        self.paragraphs = paragraphs
        super.init()
        synthesizer.delegate = self
    }
    
    public func recitade() -> Self {
        synthesizerState = .Playing
        let utterances = paragraphs.map(AVSpeechUtterance.init)
        utterances.forEach(synthesizer.speakUtterance)
        return self
    }
    
    public func stop() -> Self {
        synthesizerState = .Stopped
        print(synthesizer.stopSpeakingAtBoundary(.Immediate))
        return self
    }
    
    public func resume() -> Self {
        synthesizerState = .Playing
        print(synthesizer.continueSpeaking())
        return self
    }
    
    public func next() -> Self {
        //jump to next Paragraph
        return self
    }
    
    public func back() -> Self {
        //repeat current Paragraph or jump to last Paragraph if only not more the 2 seconds where spoken and not first Paragraph
        return self
    }
    
    public func pause() -> Self {
        synthesizerState = .Paused
        print(synthesizer.pauseSpeakingAtBoundary(.Immediate))
        return self
    }
    
    public func `repeat`() -> Self {
        //Repeat current Paragraph
        return self
    }
}

extension Resynthator: AVSpeechSynthesizerDelegate {
    public func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didPauseSpeechUtterance utterance: AVSpeechUtterance) {
       
    }
    
    public func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance) {
    
    }
    
    public func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didCancelSpeechUtterance utterance: AVSpeechUtterance) {
        
    }
    
    public func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        
    }
    
    public func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didContinueSpeechUtterance utterance: AVSpeechUtterance) {
        
    }
    
    public func speechSynthesizer(synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        synthesizerState.enforceState(on: synthesizer)
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
