//
//  Resynthator.swift
//  Resynthator
//
//  Created by Peter Schumacher on 22.06.16.
//
//

import Foundation
import AVFoundation

typealias Paragraph = String

public class Resynthator: NSObject {
    private let synthesizer: AVSpeechSynthesizer
    private var current: Paragraph?
    private var queuedAction: (() -> ())?
    
    let paragraphs: [Paragraph]
    
    convenience init(paragraph: Paragraph) {
        self.init(paragraphs: [paragraph])
    }
    
    init(paragraphs: [Paragraph]) {
        self.synthesizer = AVSpeechSynthesizer()
        self.paragraphs = paragraphs
        super.init()
        synthesizer.delegate = self
    }
    
    func recitade(range: Range<Int>) {
        let utterances = paragraphs[range].map(AVSpeechUtterance.init)
        utterances.forEach(synthesizer.speakUtterance)
    }
    
    public func recitade() -> Self {
        recitade(Range<Int>(start:0, end:paragraphs.count))
        return self
    }
    
    public func stop() {
        synthesizer.stopSpeakingAtBoundary(.Immediate)
        queuedAction = { [weak self] in self?.synthesizer.stopSpeakingAtBoundary(.Immediate) }
    }
    
    public func resume() {
        synthesizer.continueSpeaking()
    }
    
    private func stopAndStartNew(range: Range<Int>) {
        synthesizer.stopSpeakingAtBoundary(.Immediate)
        queuedAction = { [weak self] in
            self?.synthesizer.stopSpeakingAtBoundary(.Immediate)
            
            guard let strongSelf = self else { return }
            strongSelf.recitade(range)
        }
    }
    
    public func next() {
        guard let current = current, let startIndex = paragraphs.indexOf(current) else { return }
        if startIndex + 1 >= paragraphs.count {
            stop()
        } else {
            stopAndStartNew(Range<Int>(start:startIndex+1, end:paragraphs.count))
        }
    }
    
    public func back() {
        guard let current = current, let startIndex = paragraphs.indexOf(current) else { return }
        if startIndex == 0 {
            `repeat`()
        } else {
            stopAndStartNew(Range<Int>(start:startIndex-1, end:paragraphs.count))
        }
    }
    
    public func pause() {
        synthesizer.pauseSpeakingAtBoundary(.Immediate)
        queuedAction = { [weak self] in self?.synthesizer.pauseSpeakingAtBoundary(.Immediate) }
    }
    
    public func `repeat`() {
        guard let current = current, let startIndex = paragraphs.indexOf(current) else { return }
        stopAndStartNew(Range<Int>(start:startIndex, end:paragraphs.count))
    }
}

extension Resynthator: AVSpeechSynthesizerDelegate {
    public func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didPauseSpeechUtterance utterance: AVSpeechUtterance) {
        queuedAction?()
        queuedAction = nil
    }
    
    public func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance) {
        current = utterance.speechString
    }
    
    public func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didCancelSpeechUtterance utterance: AVSpeechUtterance) {
        queuedAction?()
        queuedAction = nil
    }
    
    public func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        queuedAction?()
        queuedAction = nil
    }
    
    public func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didContinueSpeechUtterance utterance: AVSpeechUtterance) {
        
    }
    
    public func speechSynthesizer(synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        queuedAction?()
        queuedAction = nil
    }
}

public extension String {
    @warn_unused_result func recitade() -> Resynthator {
        return Resynthator(paragraph: self).recitade()
    }
}

public extension SequenceType where Generator.Element == String {
    @warn_unused_result func recitade() -> Resynthator {
        return Resynthator(paragraphs: Array(self)).recitade()
    }
}
