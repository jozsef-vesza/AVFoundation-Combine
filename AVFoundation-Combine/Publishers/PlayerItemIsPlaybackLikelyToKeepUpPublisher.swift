//
//  PlayerItemLikelyToKeepUpPublisher.swift
//  AVFoundation-Combine
//
//  Created by Juan Carlos Ospina Gonzalez on 17/07/2020.
//  Copyright © 2020 József Vesza. All rights reserved.
//

import Foundation
import Combine
import AVKit

public extension Publishers {
    struct PlayerItemIsPlaybackLikelyToKeepUpPublisher: Publisher {
        public typealias Output = Bool
        public typealias Failure = Never
        
        private let playerItem: AVPlayerItem?
        
        init(playerItem: AVPlayerItem?) {
            self.playerItem = playerItem
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = PlayerItemIsPlaybackLikelyToKeepSubscription(subscriber: subscriber,
                                                      playerItem: playerItem)
            subscriber.receive(subscription: subscription)
        }
    }
    
    private final class PlayerItemIsPlaybackLikelyToKeepSubscription<S: Subscriber>: Subscription where S.Input == Bool {
        private var subscriber: S?
        private var requested: Subscribers.Demand = .none
        private var isPlaybackLikelyToKeepUpObserverToken: NSKeyValueObservation? = nil
        
        private let playerItem: AVPlayerItem?
        
        init(subscriber: S, playerItem: AVPlayerItem?) {
            self.playerItem = playerItem
            self.subscriber = subscriber
        }
        
        func request(_ demand: Subscribers.Demand) {
            requested += demand
            
            if isPlaybackLikelyToKeepUpObserverToken == nil, requested > .none {
                isPlaybackLikelyToKeepUpObserverToken = playerItem?.observe(\.isPlaybackLikelyToKeepUp) { [weak self] (playerItem, _) in
                    guard let self = self else { return }
                    self.requested -= .max(1)
                    _ = self.subscriber?.receive(playerItem.isPlaybackLikelyToKeepUp)
                }
            }
        }
        
        func cancel() {
            isPlaybackLikelyToKeepUpObserverToken?.invalidate()
            isPlaybackLikelyToKeepUpObserverToken = nil
            subscriber = nil
        }
    }
}
