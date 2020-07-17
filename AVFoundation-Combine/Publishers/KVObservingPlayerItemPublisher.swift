//
//  KVObservingPlayerItemPublisher.swift
//  AVFoundation-Combine
//
//  Created by József Vesza on 2020. 07. 17..
//  Copyright © 2020. József Vesza. All rights reserved.
//

import Foundation
import Combine
import AVKit

public extension Publishers {
    struct KVObservingPlayerItemPublisher<ObservedValue>: Publisher {
        public typealias Failure = Never
        public typealias Output = ObservedValue
        
        private let playerItem: AVPlayerItem?
        private let keyPath: KeyPath<AVPlayerItem, ObservedValue>
        
        init(playerItem: AVPlayerItem?, keyPath: KeyPath<AVPlayerItem, ObservedValue>) {
            self.playerItem = playerItem
            self.keyPath = keyPath
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = PlayerItemSubscription(subscriber: subscriber,
                                                      playerItem: playerItem,
                                                      keyPath: keyPath)
            subscriber.receive(subscription: subscription)
        }
    }
    
    private final class PlayerItemSubscription<S: Subscriber, ObservedValue>: Subscription where S.Input == ObservedValue {
        private var subscriber: S?
        private var requested: Subscribers.Demand = .none
        private var stateObserverToken: NSKeyValueObservation? = nil
        
        private let playerItem: AVPlayerItem?
        private let keyPath: KeyPath<AVPlayerItem, ObservedValue>
        
        init(subscriber: S, playerItem: AVPlayerItem?, keyPath: KeyPath<AVPlayerItem, ObservedValue>) {
            self.playerItem = playerItem
            self.subscriber = subscriber
            self.keyPath = keyPath
        }
        
        func request(_ demand: Subscribers.Demand) {
            requested += demand
            
            if stateObserverToken == nil, requested > .none {
                stateObserverToken = playerItem?.observe(keyPath, options: [.old, .new]) { [weak self] (playerItem, change) in
                    guard let self = self else { return }
                    let newValue = change.newValue ?? playerItem[keyPath: self.keyPath]
                    self.requested -= .max(1)
                    _ = self.subscriber?.receive(newValue)
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




