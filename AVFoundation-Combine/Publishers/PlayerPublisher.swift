//
//  PlayerPublisher.swift
//  AVFoundation-Combine
//
//  Created by József Vesza on 2020. 07. 17..
//  Copyright © 2020. József Vesza. All rights reserved.
//

import Foundation
import Combine
import AVKit

public extension Publishers {
    struct KVObservingPlayerPublisher<ObservedValue>: Publisher {
        public typealias Failure = Never
        public typealias Output = ObservedValue
        
        private let player: AVPlayer
        private let keyPath: KeyPath<AVPlayer, ObservedValue>
        
        init(player: AVPlayer, keyPath: KeyPath<AVPlayer, ObservedValue>) {
            self.player = player
            self.keyPath = keyPath
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = PlayerSubscription(subscriber: subscriber,
                                                  player: player,
                                                  keyPath: keyPath)
            subscriber.receive(subscription: subscription)
        }
    }
    
    private final class PlayerSubscription<S: Subscriber, ObservedValue>: Subscription where S.Input == ObservedValue {
        private var subscriber: S?
        private var requested: Subscribers.Demand = .none
        private var stateObserverToken: NSKeyValueObservation? = nil
        
        private let player: AVPlayer
        private let keyPath: KeyPath<AVPlayer, ObservedValue>
        
        init(subscriber: S, player: AVPlayer, keyPath: KeyPath<AVPlayer, ObservedValue>) {
            self.player = player
            self.subscriber = subscriber
            self.keyPath = keyPath
        }
        
        func request(_ demand: Subscribers.Demand) {
            requested += demand
            
            if stateObserverToken == nil, requested > .none {
                stateObserverToken = player.observe(keyPath, options: [.old, .new]) { [weak self] (player, change) in
                    guard let self = self else { return }
                    print("change: \(change)")
                    self.requested -= .max(1)
                    _ = self.subscriber?.receive(change.newValue!)
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



