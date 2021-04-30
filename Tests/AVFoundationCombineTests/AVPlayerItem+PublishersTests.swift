//
//  AVPlayerItem+PublishersTests.swift
//  AVFoundation-CombineTests
//
//  Created by József Vesza on 2020. 08. 09..
//

import XCTest
import Combine
import AVFoundation

@testable import AVFoundationCombine

class AVPlayerItem_PublishersTests: XCTestCase {
    
    var subscriptions = Set<AnyCancellable>()
    
    override func tearDown() {
        subscriptions = []
    }
    
    func testWhenAVPlayerItemDidPlayToEndTimeNotificationIsSent_ItEmitsAnEvent() {
        // given
        let playerItem = AVPlayerItem(url: URL(string: "https://test.url")!)
        let notificationCenter = NotificationCenter()
        var notificationReceived = false
        playerItem.didPlayToEndTimePublisher(notificationCenter).sink {_ in 
            notificationReceived = true
        }.store(in: &subscriptions)
        
        // when
        notificationCenter.post(name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        // then
        XCTAssertTrue(notificationReceived)
    }

    static var allTests = [
        ("testWhenAVPlayerItemDidPlayToEndTimeNotificationIsSent_ItEmitsAnEvent", testWhenAVPlayerItemDidPlayToEndTimeNotificationIsSent_ItEmitsAnEvent)
        ]
}
