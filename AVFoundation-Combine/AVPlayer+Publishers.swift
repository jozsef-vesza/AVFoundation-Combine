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
    typealias PlayerRatePublisher = KVObservingPublisher<AVPlayer, Float>
    typealias PlayerItemStatusPublisher = KVObservingPublisher<AVPlayerItem, AVPlayerItem.Status>
    typealias PlayerItemIsPlaybackLikelyToKeepUpPublisher = KVObservingPublisher<AVPlayerItem, Bool>
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
        return Publishers.KVObservingPublisher(observedObject: self, keyPath: keyPath)
    }
    
    /// Publisher for the `currentItem` property
    /// - Returns: Publisher for the `currentItem` property
    func currentItemPublisher() -> AnyPublisher<AVPlayerItem?, Never> {
        let keyPath: KeyPath<AVPlayer, AVPlayerItem?> = \.currentItem
        return Publishers.KVObservingPublisher(observedObject: self, keyPath: keyPath).eraseToAnyPublisher()
    }
    
    // MARK: AVPlayerItem Publishers
    
    /// Publisher for the `status` property in `AVPlayer.currentItem`
    /// - Returns: Publisher for the `status` property in `AVPlayer.currentItem`
    func statusPublisher() -> AnyPublisher<AVPlayerItem.Status, Never> {
        guard let currentItem = currentItem else {
            return Empty().eraseToAnyPublisher()
        }
        let keyPath: KeyPath<AVPlayerItem, AVPlayerItem.Status> = \.status
        return Publishers.KVObservingPublisher(observedObject: currentItem, keyPath: keyPath).eraseToAnyPublisher()
    }
    
    /// Publisher for the `isPlaybackLikelyToKeepUp` property in `AVPlayer.currentItem`
    /// - Returns: Publisher for the `isPlaybackLikelyToKeepUp` property in `AVPlayer.currentItem`
    func isPlaybackLikelyToKeepUpPublisher() -> AnyPublisher<Bool, Never> {
        guard let currentItem = currentItem else {
            return Empty().eraseToAnyPublisher()
        }
        let keyPath: KeyPath<AVPlayerItem, Bool> = \.isPlaybackLikelyToKeepUp
        return Publishers.KVObservingPublisher(observedObject: currentItem, keyPath: keyPath).eraseToAnyPublisher()
    }
}
