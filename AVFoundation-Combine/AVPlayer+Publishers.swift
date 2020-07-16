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

extension AVPlayer {
    func playheadProgressPublisher(interval: TimeInterval = 0.25) -> Publishers.PlayheadProgressPublisher {
        return Publishers.PlayheadProgressPublisher(interval: interval, player: self)
    }
    
    func statePublisher() -> Publishers.PlayerStatePublisher {
        return Publishers.PlayerStatePublisher(playerItem: self.currentItem)
    }
}

