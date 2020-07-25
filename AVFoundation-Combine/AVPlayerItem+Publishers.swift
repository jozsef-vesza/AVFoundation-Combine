//
//  AVPlayerItem+Publishers.swift
//  AVFoundation-Combine
//
//  Created by Juan Carlos Ospina Gonzalez on 17/07/2020.
//  Copyright © 2020 József Vesza. All rights reserved.
//

import Foundation
import Combine
import AVKit

public extension AVPlayerItem {
    
    /// Publisher for the `isPlaybackLikelyToKeepUp` property.
    /// A Boolean value that indicates whether the item will likely play through without stalling.
    /// - Returns: Publisher for the `isPlaybackLikelyToKeepUp` property.
    func isPlaybackLikelyToKeepUpPublisher() -> AnyPublisher<Bool, Never> {
        let keyPath: KeyPath<AVPlayerItem, Bool> = \.isPlaybackLikelyToKeepUp
        return Publishers.KVObservingPublisher(observedObject: self, keyPath: keyPath).eraseToAnyPublisher()
    }
    
    /// Publisher for the `isPlaybackBufferEmpty` property.
    /// A Boolean value that indicates whether playback has consumed all buffered media and that playback will stall or end.
    /// - Returns: Publisher for the `isPlaybackBufferEmpty` property.
    func isPlaybackBufferEmptyPublisher() -> AnyPublisher<Bool, Never> {
        let keyPath: KeyPath<AVPlayerItem, Bool> = \.isPlaybackBufferEmpty
        return Publishers.KVObservingPublisher(observedObject: self, keyPath: keyPath).eraseToAnyPublisher()
    }
    
    /// Publisher for the `status` property.
    /// A status that indicates whether the player can be used for playback.
    /// - Returns: Publisher for the `status` property.
    func statusPublisher() -> AnyPublisher<AVPlayerItem.Status, Never> {
        let keyPath: KeyPath<AVPlayerItem, AVPlayerItem.Status> = \.status
        return Publishers.KVObservingPublisher(observedObject: self, keyPath: keyPath).eraseToAnyPublisher()
    }
}
