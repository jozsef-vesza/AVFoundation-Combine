//
//  AVPlayer+Publishers.swift
//  AVFoundation-Combine
//
//  Created by József Vesza on 2020. 07. 16..
//  Copyright © 2020. József Vesza. All rights reserved.
//

import Foundation
import Combine
import AVKit

public extension AVPlayer {
    
    // MARK: - AVPlayer Publishers
    
    /// Publisher tracking playhead progress updates on `AVPlayer`
    /// - Returns: Publisher tracking playhead progress updates on `AVPlayer`
    func playheadProgressPublisher(interval: TimeInterval = 0.25) -> AnyPublisher<TimeInterval, Never> {
        Publishers.PlayheadProgressPublisher(interval: interval, player: self).eraseToAnyPublisher()
    }
    
    /// Publisher for the `rate` property.
    /// The current playback rate.
    /// - Returns: Publisher for the `rate` property.
    func ratePublisher() -> AnyPublisher<Float, Never> {
        publisher(for: \.rate).eraseToAnyPublisher()
    }
    
    /// Publisher for the `currentItem` property
    /// The player’s current player item.
    /// - Returns: Publisher for the `currentItem` property
    func currentItemPublisher() -> AnyPublisher<AVPlayerItem?, Never> {
         publisher(for: \.currentItem).eraseToAnyPublisher()
    }
}
