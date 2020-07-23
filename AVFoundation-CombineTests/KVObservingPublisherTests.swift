//
//  KVObservingPublisherTests.swift
//  AVFoundation-CombineTests
//
//  Created by József Vesza on 2020. 07. 23..
//  Copyright © 2020. József Vesza. All rights reserved.
//

import XCTest
import Combine

@testable import AVFoundation_Combine

class KVObservingPublisherTests: XCTestCase {
    var sut: Publishers.KVObservingPublisher<Counter, Int>!
    var counter: Counter!
    var subscriptions = Set<AnyCancellable>()
    
    override func setUp() {
        counter = Counter()
        sut = Publishers.KVObservingPublisher(observedObject: counter, keyPath: \.count)
    }
    
    override func tearDown() {
        subscriptions = []
    }
    
    func testWhenCounterIsIncremented_TheNewCountIsPublished() {
        // given
        let expectation = XCTestExpectation(description: "Value should be received")
        sut.sink { _ in
            expectation.fulfill()
        }
        .store(in: &subscriptions)
        
        // when
        counter.increment()
        
        // then
        wait(for: [expectation], timeout: 0)
    }
    
    func testWhenTwoValuesAreReceived_ItEmitsTwoValues() {
        // given
        let expectation = XCTestExpectation(description: "Value should be received")
        sut.sink { _ in
            expectation.fulfill()
        }
        .store(in: &subscriptions)
        
        // when
        counter.increment()
        
        // then
        wait(for: [expectation], timeout: 0)
    }
    
    func testWhenOnlyOneValueIsRequested_ItCompletesAfterEmittingOneValue() {
        // given
        let expectation = XCTestExpectation(description: "Value sould be 1")
        let expectedValue = 1
        
        let subscriber = CountSubscriber(expectedDemand: expectedValue) { finalValue in
            XCTAssertEqual(finalValue, expectedValue)
            expectation.fulfill()
        }
        
        sut.subscribe(subscriber)
        
        // when
        (0..<5).forEach { _ in counter.increment() }
        
        // then
        wait(for: [expectation], timeout: 1)
    }
}

class Counter: NSObject {
    @objc dynamic var count = 0
    
    func increment() {
        count += 1
    }
}

class CountSubscriber: Subscriber {
    typealias Input = Int
    typealias Failure = Never
    
    private(set) var receivedValue = 0
    
    let expectedDemand: Int
    let onComplete: (Int) -> Void
    
    private var subscription: Subscription? = nil
    
    init(expectedDemand: Int, onComplete: @escaping (Int) -> Void) {
        self.expectedDemand = expectedDemand
        self.onComplete = onComplete
    }
    
    func receive(subscription: Subscription) {
        self.subscription = subscription
        subscription.request(.max(expectedDemand))
    }
    
    func receive(_ input: Int) -> Subscribers.Demand {
        receivedValue = input
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        onComplete(receivedValue)
        subscription = nil
    }
}
