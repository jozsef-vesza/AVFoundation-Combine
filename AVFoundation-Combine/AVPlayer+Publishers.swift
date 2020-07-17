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
    func playheadProgressPublisher(interval: TimeInterval = 0.25) -> Publishers.PlayheadProgressPublisher {
        return Publishers.PlayheadProgressPublisher(interval: interval, player: self)
    }
    
    func statePublisher() -> Publishers.PlayerItemStatePublisher {
        return Publishers.PlayerItemStatePublisher(playerItem: self.currentItem)
    }
    
    func ratePublisher() -> Publishers.PlayerRatePublisher {
        return Publishers.PlayerRatePublisher(player: self)
    }
    
    func isPlaybackLikelyToKeepUpPublisher() ->Publishers.PlayerItemIsPlaybackLikelyToKeepUpPublisher {
        Publishers.PlayerItemIsPlaybackLikelyToKeepUpPublisher(playerItem: self.currentItem)
    }
}

