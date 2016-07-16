//
//  ResynthatorDelegateTests.swift
//  Resynthator
//
//  Created by Peter Schumacher on 16.07.16.
//
//
import XCTest
@testable import Resynthator

class ResynthatorDelegateTests: XCTestCase {
    var resynthator: Resynthator?
    let testString = "This is a Test String for the Framework"
    let testStrings = ["This is an Array of multiple Strings"," To Test if he reads also more", "and a little more"]
    
    override func tearDown() {
        resynthator?.stop()
    }
    
    var pauseDelegateCalled: Optional<(Paragraph) -> Bool> = nil
    func testDidPause() {
        let expectation = expectationWithDescription("The Text should be read then paused and the Delegate called")
        resynthator = testString.recitade()
        resynthator?.delegate = self
        
        NSTimer.schedule(delay: 1) { (timer) in
            self.resynthator?.pause()
            self.waitFor(expectation, assert: { () -> Bool in
                return self.pauseDelegateCalled?(self.testString) == true
            })
        }
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    var startDelegateCalled: Optional<(Paragraph) -> Bool> = nil
    func testDidStart() {
        let expectation = expectationWithDescription("The Text should be read and the DidStart Delegate called")
        resynthator = testString.recitade()
        resynthator?.delegate = self
        
        self.waitFor(expectation, assert: { () -> Bool in
                return self.startDelegateCalled?(self.testString) == true
        })
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    var cancelDelegateCalled: Optional<(Paragraph) -> Bool> = nil
    func testDidCancel() {
        let expectation = expectationWithDescription("The Text should be read then canceled and the Delegate called")
        resynthator = testString.recitade()
        resynthator?.delegate = self
        
        NSTimer.schedule(delay: 1) { (timer) in
            self.resynthator?.stop()
            self.waitFor(expectation, assert: { () -> Bool in
                return self.cancelDelegateCalled?(self.testString) == true
            })
        }
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    var finishDelegateCalled: Optional<(Paragraph) -> Bool> = nil
    func testDidFinish() {
        let expectation = expectationWithDescription("The Text should be read and finished and the Delegate called")
        resynthator = testString.recitade()
        resynthator?.delegate = self
        
        self.waitFor(expectation, assert: { () -> Bool in
            return self.finishDelegateCalled?(self.testString) == true
        })
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    var continueDelegateCalled: Optional<(Paragraph) -> Bool> = nil
    func testDidContinue() {
        let expectation = expectationWithDescription("The Text should be read then paused then coninued and the Delegate called")
        resynthator = testString.recitade()
        resynthator?.delegate = self
        
        NSTimer.schedule(delay: 1) { (timer) in
            self.resynthator?.pause()
            NSTimer.schedule(delay: 1) { (timer) in
                self.resynthator?.resume()
                self.waitFor(expectation, assert: { () -> Bool in
                    return self.continueDelegateCalled?(self.testString) == true
                })
            }
        }
        waitForExpectationsWithTimeout(5, handler: nil)
    }
}

extension ResynthatorDelegateTests: ResynthatorDelegate {
    func didPause(at paragraph: Paragraph) {
        pauseDelegateCalled = { expected in
            return paragraph == expected
        }
    }
    
    func didStart(paragraph: Paragraph) {
        startDelegateCalled = { expected in
            return paragraph == expected
        }
    }
    
    func didCancel(paragraph: Paragraph) {
        cancelDelegateCalled = { expected in
            return paragraph == expected
        }
    }
    
    func didFinish(paragraph: Paragraph) {
        finishDelegateCalled = { expected in
            return paragraph == expected
        }
    }
    
    func didContinue(paragraph: Paragraph) {
        continueDelegateCalled = { expected in
            return paragraph == expected
        }
    }
}