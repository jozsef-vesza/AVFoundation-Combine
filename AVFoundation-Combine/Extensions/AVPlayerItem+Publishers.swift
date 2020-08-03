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
        publisher(for: \.isPlaybackLikelyToKeepUp).eraseToAnyPublisher()
    }
    
    /// Publisher for the `isPlaybackBufferEmpty` property.
    /// A Boolean value that indicates whether playback has consumed all buffered media and that playback will stall or end.
    /// - Returns: Publisher for the `isPlaybackBufferEmpty` property.
    func isPlaybackBufferEmptyPublisher() -> AnyPublisher<Bool, Never> {
        publisher(for: \.isPlaybackBufferEmpty).eraseToAnyPublisher()
    }
    
    /// Publisher for the `status` property.
    /// A status that indicates whether the player can be used for playback.
    /// - Returns: Publisher for the `status` property.
    func statusPublisher() -> AnyPublisher<AVPlayerItem.Status, Never> {
        publisher(for: \.status).eraseToAnyPublisher()
    }
    
    /// Publisher for the `duration` property
    func durationPublisher() -> AnyPublisher<CMTime, Never> {
        let keyPath: KeyPath<AVPlayerItem, CMTime> = \.duration
         return Publishers.KVObservingPublisher(observedObject: self, keyPath: keyPath).eraseToAnyPublisher()
    }
}
