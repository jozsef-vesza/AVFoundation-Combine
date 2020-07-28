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
    
    func testWhenDemandIsUnlimited_AndCounterIsIncremented_ItEmitsTheNewValue() {
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
    
    func testWhenDemandIsUnlimited_AndCounterIsIncrementedTwice_ItEmitsTwoValues() {
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
    
    func testWhenDemandIsZero_ItEmitsNoValues() {
        // given
        let expectedValues: [Int] = []
        var receivedValues: [Int] = []
        
        let subscriber = TestSubscriber<Int>(demand: 0) { values in
            receivedValues = values
        }
        
        sut.subscribe(subscriber)
        
        // when
        (0..<5).forEach { _ in counter.increment() }
        
        // then
        XCTAssertEqual(receivedValues, expectedValues)
    }
    
    func testWhenInitialDemandIsZero_AndThenFiveValuesAreRequested_ItEmitsFiveValues() {
        // given
        let expectedValues: [Int] = [1, 2, 3, 4, 5]
        var receivedValues: [Int] = []
        
        let subscriber = TestSubscriber<Int>(demand: 0) { values in
            receivedValues = values
        }
        
        sut.subscribe(subscriber)
        
        // when
        subscriber.startRequestingValues(5)
        
        (0..<5).forEach { _ in counter.increment() }
        
        // then
        XCTAssertEqual(receivedValues, expectedValues)
    }
    
    func testWhenDemandIsOne_ItCompletesAfterEmittingOneValue() {
        // given
        let expectedValues = [1]
        var receivedValues: [Int] = []
        
        let subscriber = TestSubscriber<Int>(demand: 1) { values in
            receivedValues = values
        }
        
        sut.subscribe(subscriber)
        
        // when
        (0..<5).forEach { _ in counter.increment() }
        
        // then
        XCTAssertEqual(receivedValues, expectedValues)
    }
    
    func testWhenDemandIsTwo_ItCompletesAfterEmittingTwoValues() {
        // given
        let expectedValues = [1, 2]
        var receivedValues: [Int] = []
        
        let subscriber = TestSubscriber<Int>(demand: 2) { values in
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
