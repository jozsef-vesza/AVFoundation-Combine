//
//  KVObservingPublisher.swift
//  AVFoundation-Combine
//
//  Created by József Vesza on 2020. 07. 17..
//  Copyright © 2020. József Vesza. All rights reserved.
//

import Foundation
import Combine
import AVKit

public extension Publishers {
    struct KVObservingPublisher<ObservedType: NSObject, ObservedValue>: Publisher {
        public typealias Failure = Never
        public typealias Output = ObservedValue
        
        private let observedObject: ObservedType
        private let keyPath: KeyPath<ObservedType, ObservedValue>
        
        init(observedObject: ObservedType, keyPath: KeyPath<ObservedType, ObservedValue>) {
            self.observedObject = observedObject
            self.keyPath = keyPath
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = KVObservingSubscription(subscriber: subscriber,
                                                       observedObject: observedObject,
                                                       keyPath: keyPath)
            subscriber.receive(subscription: subscription)
        }
    }
    
    private final class KVObservingSubscription<S: Subscriber, ObservedType: NSObject, ObservedValue>: Subscription where S.Input == ObservedValue {
        private var subscriber: S?
        private var requested: Subscribers.Demand = .none
        private var observationToken: NSKeyValueObservation? = nil
        
        private let observedObject: ObservedType
        private let keyPath: KeyPath<ObservedType, ObservedValue>
        
        init(subscriber: S, observedObject: ObservedType, keyPath: KeyPath<ObservedType, ObservedValue>) {
            self.observedObject = observedObject
            self.subscriber = subscriber
            self.keyPath = keyPath
        }
        
        func request(_ demand: Subscribers.Demand) {
            guard demand > .none else {
                subscriber?.receive(completion: .finished)
                return
            }
            requested += demand
            
            if observationToken == nil, requested > .none {
                observationToken = observedObject.observe(keyPath, options: [.old, .new]) { [weak self] (object, change) in
                    guard let self = self, let subscriber = self.subscriber else { return }
                    let newValue = change.newValue ?? object[keyPath: self.keyPath]
                    let newDemand = subscriber.receive(newValue)
                    
                    if newDemand == .none {
                        subscriber.receive(completion: .finished)
                    }
                }
            }
        }
        
        func cancel() {
            observationToken?.invalidate()
            observationToken = nil
            subscriber = nil
        }
    }
}



