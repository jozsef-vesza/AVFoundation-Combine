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

public extension Publishers {
    typealias PlayerRatePublisher = KVObservingPlayerPublisher<Float>
    typealias PlayerItemStatusPublisher = KVObservingPlayerItemPublisher<AVPlayerItem.Status>
    typealias PlayerItemIsPlaybackLikelyToKeepUpPublisher = KVObservingPlayerItemPublisher<Bool>
}

public extension AVPlayer {
    
    // MARK: AVPlayer Publishers
    
    /// Publisher tracking playhead progress updates on `AVPlayer`
    /// - Returns: Publisher tracking playhead progress updates on `AVPlayer`
    func playheadProgressPublisher(interval: TimeInterval = 0.25) -> Publishers.PlayheadProgressPublisher {
        Publishers.PlayheadProgressPublisher(interval: interval, player: self)
    }
    
    /// Publisher for the `rate` property.
    /// - Returns: Publisher for the `rate` property.
    func ratePublisher() -> Publishers.PlayerRatePublisher {
        let keyPath: KeyPath<AVPlayer, Float> = \.rate
        return Publishers.KVObservingPlayerPublisher<Float>(player: self, keyPath: keyPath)
    }
    
    // MARK: AVPlayerItem Publishers
    
    /// Publisher for the `status` property in `AVPlayer.currentItem`
    /// - Returns: Publisher for the `status` property in `AVPlayer.currentItem`
    func statusPublisher() -> Publishers.PlayerItemStatusPublisher {
        let keyPath: KeyPath<AVPlayerItem, AVPlayerItem.Status> = \.status
        return Publishers.KVObservingPlayerItemPublisher(playerItem: currentItem, keyPath: keyPath)
    }
    
    /// Publisher for the `isPlaybackLikelyToKeepUp` property in `AVPlayer.currentItem`
    /// - Returns: Publisher for the `isPlaybackLikelyToKeepUp` property in `AVPlayer.currentItem`
    func isPlaybackLikelyToKeepUpPublisher() -> Publishers.PlayerItemIsPlaybackLikelyToKeepUpPublisher {
        let keyPath: KeyPath<AVPlayerItem, Bool> = \.isPlaybackLikelyToKeepUp
        return Publishers.KVObservingPlayerItemPublisher(playerItem: currentItem, keyPath: keyPath)
    }
}
