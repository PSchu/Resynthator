//
//  ResynthatorTests.swift
//  ResynthatorTests
//
//  Created by Peter Schumacher on 22.06.16.
//
//

import XCTest
@testable import Resynthator

extension XCTestCase {
    func waitFor(expectation: XCTestExpectation, assert: () -> Bool) {
        NSTimer.schedule(repeatInterval: 0.1) { timer in
            if assert() {
                timer.invalidate()
                expectation.fulfill()
            } else {
                print("Not Yet")
            }
        }
    }
}

class ResynthatorTests: XCTestCase {
    var resynthator: Resynthator?
    let testString = "This is a Test String for the Framework"
    let testStrings = ["This is an Array of multiple Strings"," To Test if he reads also more", "and a little more"]
    
    override func tearDown() {
        resynthator?.stop()
    }
    
    func testReadSingleText() {
        let expectation = expectationWithDescription("The Text should be read")
        resynthator = testString.recitade()
        waitFor(expectation) {
            guard let synth = self.resynthator?.synthesizer else { return false }
            return synth.speaking
        }
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testPause() {
        let expectation = expectationWithDescription("The Text should be read then paused")
        resynthator = testString.recitade()
        NSTimer.schedule(delay: 2) { (timer) in
            self.resynthator?.pause()
            self.waitFor(expectation, assert: { () -> Bool in
                guard let synth = self.resynthator?.synthesizer else { return false }
                return synth.paused
            })
        }
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testResume() {
        let expectation = expectationWithDescription("The Text should be read then paused then resumed")
        resynthator = testStrings.recitade()
        NSTimer.schedule(delay: 1) { (timer) in
            self.resynthator?.pause()
            NSTimer.schedule(delay: 1) { (timer) in
                self.resynthator?.resume()
                self.waitFor(expectation, assert: { () -> Bool in
                    guard let synth = self.resynthator?.synthesizer else { return false }
                    return synth.speaking
                })
            }
        }
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    var didFinish: Optional<() -> ()> = nil
    func testPauseInbetweenUtterances() {
        let expectation = expectationWithDescription("The first Utterance/Paragraph should be read and then it should be paused befor the second starts")
        resynthator = testStrings.recitade()
        resynthator?.delegate = self
        didFinish = {
            self.resynthator?.pause()
        }
        waitFor(expectation) { () -> Bool in
            guard let synth = self.resynthator?.synthesizer else { return false }
            return synth.paused
        }
        waitForExpectationsWithTimeout(5, handler: nil)
    }
}

extension ResynthatorTests: ResynthatorDelegate {
    func didFinish(paragraph: Paragraph) {
        didFinish?()
    }
}
