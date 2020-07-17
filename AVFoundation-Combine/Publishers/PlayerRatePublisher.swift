//
//  PlayerRatePublisher.swift
//  AVFoundation-Combine
//
//  Created by József Vesza on 2020. 07. 16..
//  Copyright © 2020. József Vesza. All rights reserved.
//

import Foundation
import Combine
import AVKit

public extension Publishers {
    struct PlayerRatePublisher: Publisher {
        public typealias Output = Float
        public typealias Failure = Never
        
        private let player: AVPlayer
        
        init(player: AVPlayer) {
            self.player = player
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = PlayerRateSubscription(subscriber: subscriber,
                                                      player: player)
            subscriber.receive(subscription: subscription)
        }
    }
    
    private final class PlayerRateSubscription<S: Subscriber>: Subscription where S.Input == Float {
        private var subscriber: S?
        private var requested: Subscribers.Demand = .none
        private var stateObserverToken: NSKeyValueObservation? = nil
        
        private let player: AVPlayer
        
        init(subscriber: S, player: AVPlayer) {
            self.player = player
            self.subscriber = subscriber
        }
        
        func request(_ demand: Subscribers.Demand) {
            requested += demand
            
            if stateObserverToken == nil, requested > .none {
                stateObserverToken = player.observe(\.rate) { [weak self] (player, _) in
                    guard let self = self else { return }
                    self.requested -= .max(1)
                    _ = self.subscriber?.receive(player.rate)
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


