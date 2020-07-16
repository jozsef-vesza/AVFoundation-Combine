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

extension Publishers {
    struct PlayerStatePublisher: Publisher {
        typealias Output = AVPlayerItem.Status
        typealias Failure = Never
        
        private let playerItem: AVPlayerItem?
        
        init(playerItem: AVPlayerItem?) {
            self.playerItem = playerItem
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = PlayerStateSubscription(subscriber: subscriber,
                                                       playerItem: playerItem)
            subscriber.receive(subscription: subscription)
        }
    }
    
    private final class PlayerStateSubscription<S: Subscriber>: Subscription where S.Input == AVPlayerItem.Status {
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
                    _ = self?.subscriber?.receive(item.status)
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
