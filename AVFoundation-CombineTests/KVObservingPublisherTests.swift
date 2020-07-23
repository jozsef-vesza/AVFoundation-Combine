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
    
    func testWhenCounterIsIncremented_ItEmitsTheNewValue() {
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
    
    func testWhenCounterIsIncrementedTwice_ItEmitsTwoValues() {
        // given
        let expectedValues = [1, 2]
        var receivedValues: [Int] = []
        
        sut.sink { value in
            receivedValues.append(value)
        }
        .store(in: &subscriptions)
        
        // when
        counter.increment()
        counter.increment()
        
        // then
        XCTAssertEqual(receivedValues, expectedValues)
    }
    
    func testWhenOnlyOneValueIsRequested_ItCompletesAfterEmittingOneValue() {
        // given
        let expectedValues = [1]
        var receivedValues: [Int] = []
        
        let subscriber = CountSubscriber(demand: 1) { values in
            receivedValues = values
        }
        
        sut.subscribe(subscriber)
        
        // when
        (0..<5).forEach { _ in counter.increment() }
        
        // then
        XCTAssertEqual(receivedValues, expectedValues)
    }
    
    func testWhenTwoValuesAreRequested_ItCompletesAfterEmittingTwoValues() {
        // given
        let expectedValues = [1, 2]
        var receivedValues: [Int] = []
        
        let subscriber = CountSubscriber(demand: 2) { values in
            receivedValues = values
        }
        
        sut.subscribe(subscriber)
        
        // when
        (0..<5).forEach { _ in counter.increment() }
        
        // then
        XCTAssertEqual(receivedValues, expectedValues)
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
    
    let demand: Int
    let onComplete: ([Int]) -> Void
    
    private var receivedValues: [Int] = []
    private var subscription: Subscription? = nil
    
    init(demand: Int, onComplete: @escaping ([Int]) -> Void) {
        self.demand = demand
        self.onComplete = onComplete
    }
    
    func receive(subscription: Subscription) {
        self.subscription = subscription
        subscription.request(.max(demand))
    }
    
    func receive(_ input: Int) -> Subscribers.Demand {
        receivedValues.append(input)
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        onComplete(receivedValues)
        subscription = nil
    }
}
