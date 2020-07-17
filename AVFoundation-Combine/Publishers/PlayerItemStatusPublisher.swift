//
//  PlayerStatePublisher.swift
//  AVFoundation-Combine
//
//  Created by József Vesza on 2020. 07. 16..
//  Copyright © 2020. József Vesza. All rights reserved.
//

import Foundation
import Combine
import AVKit

public extension Publishers {
    struct PlayerItemStatusPublisher: Publisher {
        public typealias Output = AVPlayerItem.Status
        public typealias Failure = Never
        
        private let playerItem: AVPlayerItem?
        
        init(playerItem: AVPlayerItem?) {
            self.playerItem = playerItem
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = PlayerItemStatusSubscription(subscriber: subscriber,
                                                       playerItem: playerItem)
            subscriber.receive(subscription: subscription)
        }
    }
    
    private final class PlayerItemStatusSubscription<S: Subscriber>: Subscription where S.Input == AVPlayerItem.Status {
        private var subscriber: S?
        private var requested: Subscribers.Demand = .none
        private var stateObserverToken: NSKeyValueObservation? = nil
        
        private let playerItem: AVPlayerItem?
        
        init(subscriber: S, playerItem: AVPlayerItem?) {
            self.playerItem = playerItem
            self.subscriber = subscriber
        }
        
        func request(_ demand: Subscribers.Demand) {
            requested += demand
            
            if stateObserverToken == nil, requested > .none {
                stateObserverToken = playerItem?.observe(\.status) { [weak self] (item, _) in
                    guard let self = self else { return }
                    self.requested -= .max(1)
                    _ = self.subscriber?.receive(item.status)
                }
            }
        }
        
        func cancel() {
            stateObserverToken?.invalidate()
            stateObserverToken = nil
            subscriber = nil
        }
    }
}

