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
    /// - Returns: Publisher for the `isPlaybackLikelyToKeepUp` property.
    func isPlaybackLikelyToKeepUpPublisher() -> Publishers.PlayerItemIsPlaybackLikelyToKeepUpPublisher {
        let keyPath: KeyPath<AVPlayerItem, Bool> = \.isPlaybackLikelyToKeepUp
        return Publishers.KVObservingPublisher(observedObject: self, keyPath: keyPath)
    }
    
    /// Publisher for the `status` property.
    /// - Returns: Publisher for the `status` property.
    func statusPublisher() -> Publishers.PlayerItemStatusPublisher {
        let keyPath: KeyPath<AVPlayerItem, AVPlayerItem.Status> = \.status
        return Publishers.KVObservingPublisher(observedObject: self, keyPath: keyPath)
    }
}
