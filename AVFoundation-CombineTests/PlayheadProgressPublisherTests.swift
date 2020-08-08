//
//  PlayheadProgressPublisherTests.swift
//  AVFoundation-CombineTests
//
//  Created by József Vesza on 2020. 07. 24..
//  Copyright © 2020. József Vesza. All rights reserved.
//

import XCTest
import Combine
import AVFoundation

@testable import AVFoundation_Combine

class PlayheadProgressPublisherTests: XCTestCase {
    var sut: Publishers.PlayheadProgressPublisher!
    var player: MockAVPlayer!
    var subscriptions = Set<AnyCancellable>()
    
    override func setUp() {
        player = MockAVPlayer()
        sut = Publishers.PlayheadProgressPublisher(player: player)
    }
    
    override func tearDown() {
        subscriptions = []
    }
    
    func testWhenDemandIsUnlimited_AndTimeIsUpdated_ItEmitsTheNewTime() {
        var receivedTimes: [TimeInterval] = []
        let expectedTimes: [TimeInterval] = [1]
        sut.sink { time in
            receivedTimes.append(time)
        }
        .store(in: &subscriptions)
        
        for time in expectedTimes {
            player.updateClosure?(CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        }
        
        XCTAssertEqual(receivedTimes, expectedTimes)
    }
    
    func testWhenDemandIsUnlimited_AndTimeIsUpdatedTwice_ItEmitsTheNewTimes() {
        var receivedTimes: [TimeInterval] = []
        let expectedTimes: [TimeInterval] = [1, 2]
        sut.sink { time in
            receivedTimes.append(time)
        }
        .store(in: &subscriptions)
        
        for time in expectedTimes {
            player.updateClosure?(CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        }
        
        XCTAssertEqual(receivedTimes, expectedTimes)
    }
    
    func testWhenDemandIsZero_ItEmitsNoValues() {
        // given
        let expectedValues: [TimeInterval] = []
        var receivedValues: [TimeInterval] = []
        
        let subscriber = TestSubscriber<TimeInterval>(demand: 0) { value in
            receivedValues.append(value)
            return 0
        }
        
        sut.subscribe(subscriber)
        
        let timeUpdates: [TimeInterval] = [1, 2, 3, 4, 5]
        
        // when
        timeUpdates.forEach { time in player.updateClosure?(CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))) }
        
        // then
        XCTAssertEqual(receivedValues, expectedValues)
    }
    
    func testWhenDemandIsZero_ItDoesNotCompleteImmediately() {
        // given
        var completed = false
        
        let subscriber = TestSubscriber<TimeInterval>(demand: 0, onComplete: {
            completed = true
        })
        
        // when
        sut.subscribe(subscriber)
        
        // then
        XCTAssertFalse(completed)
    }
    
    func testWhenInitialDemandIsZero_AndThenFiveValuesAreRequested_ItEmitsFiveValues() {
        // given
        let expectedValues: [TimeInterval] = [1, 2, 3, 4, 5]
        var receivedValues: [TimeInterval] = []
        
        let subscriber = TestSubscriber<TimeInterval>(demand: 0) { value in
            receivedValues.append(value)
            return 0
        }
        
        sut.subscribe(subscriber)
        
        let timeUpdates: [TimeInterval] = [1, 2, 3, 4, 5]
        
        // when
        subscriber.startRequestingValues(5)
        
        timeUpdates.forEach { time in player.updateClosure?(CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))) }
        
        // then
        XCTAssertEqual(receivedValues, expectedValues)
    }
    
    func testWhenDemandIsOne_ItEmitsOneValue() {
        // given
        let expectedValues: [TimeInterval] = [1]
        var receivedValues: [TimeInterval] = []
        
        let subscriber = TestSubscriber<TimeInterval>(demand: 1) { value in
            receivedValues.append(value)
            return 0
        }
        
        sut.subscribe(subscriber)
        
        let timeUpdates: [TimeInterval] = [1, 2, 3, 4, 5]
        
        // when
        timeUpdates.forEach { time in player.updateClosure?(CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))) }
        
        // then
        XCTAssertEqual(receivedValues, expectedValues)
    }
    
    func testWhenDemandIsTwo_ItEmitsTwoValues() {
        // given
        let expectedValues: [TimeInterval] = [1, 2]
        var receivedValues: [TimeInterval] = []
        
        let subscriber = TestSubscriber<TimeInterval>(demand: 2) { value in
            receivedValues.append(value)
            return 0
        }
        
        sut.subscribe(subscriber)
        
        let timeUpdates: [TimeInterval] = [1, 2, 3, 4, 5]
        
        // when
        timeUpdates.forEach { time in player.updateClosure?(CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))) }
        
        // then
        XCTAssertEqual(receivedValues, expectedValues)
    }
    
    func testWhenInitialDemandIsOne_AndAnAdditionalValueIsRequested_ItEmitsTwoValues() {
        // given
        let expectedValues: [TimeInterval] = [1, 2]
        var receivedValues: [TimeInterval] = []
        
        let subscriber = TestSubscriber<TimeInterval>(demand: 1) { value in
            receivedValues.append(value)
            return value == 1 ? 1 : 0
        }
        
        sut.subscribe(subscriber)
        
        let timeUpdates: [TimeInterval] = [1, 2, 3, 4, 5]
        
        // when
        timeUpdates.forEach { time in player.updateClosure?(CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))) }
        
        // then
        XCTAssertEqual(receivedValues, expectedValues)
    }
    
    func testWhenInitialDemandIsOne_AndNoMoreValuesAreRequested_ThenMoreValuesAreRequested_ItEmitsMoreValues() {
        // given
        let expectedValues: [TimeInterval] = [1, 3]
        var receivedValues: [TimeInterval] = []

        let subscriber = TestSubscriber<TimeInterval>(demand: 1) { value in
            receivedValues.append(value)
            return 0
        }
        
        sut.subscribe(subscriber)
        player.updateClosure?(CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        player.updateClosure?(CMTime(seconds: 2, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        
        // when
        subscriber.startRequestingValues(1)
        player.updateClosure?(CMTime(seconds: 3, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        
        // then
        XCTAssertEqual(receivedValues, expectedValues)
    }
    
    func testWhenSubscriptionIsCancelled_ItStopsObservingThePlayback() {
        // given
        let subscription = sut.sink(receiveCompletion: { _ in }, receiveValue: { _ in  })
        
        // when
        subscription.cancel()
        
        // then
        XCTAssertTrue(player.timeObserverRemoved)
    }
    
    func testWhenValuesAreRequestedFromMultipleThreads_RequestsAreSerialized() {
        // given
        let requestCount = 1000
        let expectation = XCTestExpectation(description: "\(requestCount) values should be received")
        expectation.expectedFulfillmentCount = requestCount
        
        let subscriber = TestSubscriber<TimeInterval>(demand: 0) { _ in
            expectation.fulfill()
            return 0
        }
        
        sut.subscribe(subscriber)
        
        let group = DispatchGroup()
        
        for _ in 0..<requestCount {
            group.enter()
            DispatchQueue.global().async {
                subscriber.startRequestingValues(1)
                group.leave()
            }
        }
        
        _ = group.wait(timeout: DispatchTime.now() + 5)
        
        // when
        (1...requestCount).map { TimeInterval($0) }.forEach { time in
            player.updateClosure?(CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        }
        
        // then
        wait(for: [expectation], timeout: 1)
    }
    
    func testWhenRequestAndDemandUpdateAreSentFromDifferentThreads_UpdatesAreSerialized() {
        // given
        let expectation = XCTestExpectation(description: "1 value should be received")
        expectation.expectedFulfillmentCount = 1
        
        let subscriber = TestSubscriber<TimeInterval>(demand: 0) { _ in
            expectation.fulfill()
            return 0
        }
        
        sut.subscribe(subscriber)
        subscriber.startRequestingValues(1)
        
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global().async {
            subscriber.startRequestingValues(1)
            group.leave()
        }
        
        player.updateClosure?(CMTime(seconds: TimeInterval(1), preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        
        _ = group.wait(timeout: DispatchTime.now() + 5)
        
        // then
        wait(for: [expectation], timeout: 1)
    }
}

/// Mock AVPlayer implementation.
///
/// By overriding `AVPlayer.addPeriodicTimeObserver(forInterval:queue:using:)`
/// it can capture the method's `block` parameter, which it can use to post arbitrary progress updates.
///
class MockAVPlayer: AVPlayer {
    /// Closure to use for posting an arbitrary progress update.
    ///
    /// Usage:
    /// Subscribe to progress updates.
    /// This will invoke `addPeriodicTimeObserver(forInterval:queue:using:)`
    /// which allows the mock to capture the update closure:
    /// ```
    /// Publishers.PlayheadProgressPublisher(player: player).sink {}
    /// ```
    /// Then the mock can be used to post arbitrary progress updates:
    /// ```
    /// player.updateClosure?(10)
    /// ```
    ///
    var updateClosure: ((_ time: CMTime) -> Void)?
    /// A flag to check if the time observer is invalidated upon cancellation
    var timeObserverRemoved = false
    
    override func addPeriodicTimeObserver(forInterval interval: CMTime,
                                          queue: DispatchQueue?,
                                          using block: @escaping (CMTime) -> Void) -> Any {
        updateClosure = block
        return super.addPeriodicTimeObserver(forInterval: interval, queue: queue, using: { _ in })
    }
    
    override func removeTimeObserver(_ observer: Any) {
        timeObserverRemoved = true
        super.removeTimeObserver(observer)
    }
}
