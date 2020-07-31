//
//  PlayheadProgressPublisher.swift
//  AVFoundation-Combine
//
//  Created by József Vesza on 2020. 07. 16..
//  Copyright © 2020. József Vesza. All rights reserved.
//

import Foundation
import Combine
import AVKit

public extension Publishers {
    struct PlayheadProgressPublisher: Publisher {
        public typealias Output = TimeInterval
        public typealias Failure = Never
        
        private let interval: TimeInterval
        private let player: AVPlayer
        
        init(interval: TimeInterval = 0.25, player: AVPlayer) {
            self.player = player
            self.interval = interval
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = PlayheadProgressSubscription(subscriber: subscriber,
                                                            interval: interval,
                                                            player: player)
            subscriber.receive(subscription: subscription)
        }
    }
    
    private final class PlayheadProgressSubscription<S: Subscriber>: Subscription where S.Input == TimeInterval {
        private var subscriber: S?
        private var requested: Subscribers.Demand = .none
        private var timeObserverToken: Any? = nil
        
        private let interval: TimeInterval
        private let player: AVPlayer
        
        init(subscriber: S, interval: TimeInterval = 0.25, player: AVPlayer) {
            self.player = player
            self.subscriber = subscriber
            self.interval = interval
        }
        
        func request(_ demand: Subscribers.Demand) {
            requested += demand
            guard timeObserverToken == nil, requested > .none else { return }
            
            let interval = CMTime(seconds: self.interval, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
                guard let self = self, let subscriber = self.subscriber else { return }
                self.requested -= .max(1)
                let newDemand = subscriber.receive(time.seconds)
                self.requested += newDemand
                
                if self.requested == .none {
                    subscriber.receive(completion: .finished)
                }
            }
        }
        
        func cancel() {
            if let timeObserverToken = timeObserverToken {
                player.removeTimeObserver(timeObserverToken)
            }
            timeObserverToken = nil
            subscriber = nil
        }
    }
}

