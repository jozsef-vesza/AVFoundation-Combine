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
    
    func testWhenTimeIsUpdated_ItEmitsTheNewTime() {
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
    
    func testWhenTimeIsUpdatedTwice_ItEmitsTheNewTimes() {
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
    
    func testWhenNoValuesAreRequested_ItEmitsNoValues() {
        // given
        let expectedValues: [TimeInterval] = []
        var receivedValues: [TimeInterval] = []
        
        let subscriber = TestSubscriber<TimeInterval>(demand: 0) { values in
            receivedValues = values
        }
        
        sut.subscribe(subscriber)
        
        let timeUpdates: [TimeInterval] = [1, 2, 3, 4, 5]
        
        // when
        timeUpdates.forEach { time in player.updateClosure?(CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))) }
        
        // then
        XCTAssertEqual(receivedValues, expectedValues)
    }
    
    func testWhenValuesAreRequested_ItStartsEmittingValues() {
        // given
        let expectedValues: [TimeInterval] = [1, 2, 3, 4, 5]
        var receivedValues: [TimeInterval] = []
        
        let subscriber = TestSubscriber<TimeInterval>(demand: 0) { values in
            receivedValues = values
        }
        
        sut.subscribe(subscriber)
        
        let timeUpdates: [TimeInterval] = [1, 2, 3, 4, 5]
        
        // when
        subscriber.startRequestingValues(5)
        
        timeUpdates.forEach { time in player.updateClosure?(CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))) }
        
        // then
        XCTAssertEqual(receivedValues, expectedValues)
    }
    
    func testWhenOnlyOneValueIsRequested_ItCompletesAfterEmittingOneValue() {
        // given
        let expectedValues: [TimeInterval] = [1]
        var receivedValues: [TimeInterval] = []
        
        let subscriber = TestSubscriber<TimeInterval>(demand: 1) { values in
            receivedValues = values
        }
        
        sut.subscribe(subscriber)
        
        let timeUpdates: [TimeInterval] = [1, 2, 3, 4, 5]
        
        // when
        timeUpdates.forEach { time in player.updateClosure?(CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))) }
        
        // then
        XCTAssertEqual(receivedValues, expectedValues)
    }
    
    func testWhenTwoValuesAreRequested_ItCompletesAfterEmittingTwoValues() {
        // given
        let expectedValues: [TimeInterval] = [1, 2]
        var receivedValues: [TimeInterval] = []
        
        let subscriber = TestSubscriber<TimeInterval>(demand: 2) { values in
            receivedValues = values
        }
        
        sut.subscribe(subscriber)
        
        let timeUpdates: [TimeInterval] = [1, 2, 3, 4, 5]
        
        // when
        timeUpdates.forEach { time in player.updateClosure?(CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))) }
        
        // then
        XCTAssertEqual(receivedValues, expectedValues)
    }
}

class MockAVPlayer: AVPlayer {
    var updateClosure: ((CMTime) -> Void)?
    
    override func addPeriodicTimeObserver(forInterval interval: CMTime,
                                          queue: DispatchQueue?,
                                          using block: @escaping (CMTime) -> Void) -> Any {
        updateClosure = block
        return super.addPeriodicTimeObserver(forInterval: interval, queue: queue, using: block)
    }
}
