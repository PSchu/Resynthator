//
//  Resynthator.swift
//  Resynthator
//
//  Created by Peter Schumacher on 22.06.16.
//
//

import Foundation
import AVFoundation

public typealias Paragraph = String

public protocol ResynthatorDelegate: class {
    func didPause(at paragraph: Paragraph)
    func didStart(paragraph: Paragraph)
    func didCancel(paragraph: Paragraph)
    func didFinish(paragraph: Paragraph)
    func didContinue(paragraph: Paragraph)
}

extension ResynthatorDelegate {
    func didPause(at paragraph: Paragraph) {}
    func didStart(paragraph: Paragraph) {}
    func didCancel(paragraph: Paragraph) {}
    func didFinish(paragraph: Paragraph) {}
    func didContinue(paragraph: Paragraph) {}
}

public class Resynthator: NSObject {
    let synthesizer: AVSpeechSynthesizer
    private var current: Paragraph?
    private var queuedAction: (() -> ())?
    public weak var delegate: ResynthatorDelegate?
    
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
        recitade(Range<Int>(0..<paragraphs.count))
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
            stopAndStartNew(Range<Int>(startIndex+1..<paragraphs.count))
        }
    }
    
    public func back() {
        guard let current = current, let startIndex = paragraphs.indexOf(current) else { return }
        if startIndex == 0 {
            `repeat`()
        } else {
            stopAndStartNew(Range<Int>(startIndex-1..<paragraphs.count))
        }
    }
    
    public func pause() {
        synthesizer.pauseSpeakingAtBoundary(.Immediate)
        queuedAction = { [weak self] in self?.synthesizer.pauseSpeakingAtBoundary(.Immediate) }
    }
    
    public func `repeat`() {
        guard let current = current, let startIndex = paragraphs.indexOf(current) else { return }
        stopAndStartNew(Range<Int>(startIndex..<paragraphs.count))
    }
}

private extension CollectionType where Generator.Element == Paragraph {

}

extension Resynthator: AVSpeechSynthesizerDelegate {
    public func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didPauseSpeechUtterance utterance: AVSpeechUtterance) {
        delegate?.didPause(at: utterance.speechString)
        queuedAction?()
        queuedAction = nil
    }
    
    public func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance) {
        delegate?.didStart(utterance.speechString)
        current = utterance.speechString
    }
    
    public func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didCancelSpeechUtterance utterance: AVSpeechUtterance) {
        delegate?.didCancel(utterance.speechString)
        queuedAction?()
        queuedAction = nil
    }
    
    public func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        delegate?.didFinish(utterance.speechString)
//        queuedAction?()
//        queuedAction = nil
    }
    
    public func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didContinueSpeechUtterance utterance: AVSpeechUtterance) {
        delegate?.didContinue(utterance.speechString)
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
