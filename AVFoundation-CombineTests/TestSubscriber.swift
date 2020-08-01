//
//  TestSubscriber.swift
//  AVFoundation-CombineTests
//
//  Created by József Vesza on 2020. 07. 24..
//  Copyright © 2020. József Vesza. All rights reserved.
//

import Combine

/// A Subscriber implementation that allows specifying de amount of values to demand.
class TestSubscriber<T>: Subscriber {
    typealias Input = T
    typealias Failure = Never
    
    private let demand: Int
    private let onComplete: ([T]) -> Void
    private let onValueReceived: (T) -> Int
    
    private var receivedValues: [T] = []
    private var subscription: Subscription? = nil
    
    /// Initializes a `TestSubscriber` instance
    /// - Parameters:
    ///   - demand: the amount of values to demand from the Publisher
    ///   - onComplete: a closure to invoke when the subscription completes.
    ///   - receivedValues: array containing the values received by the Subscriber before completion
    ///   - onValueReceived: a closure to invoke when the subscription emits a value. Use this method to alter the demand.
    ///   - receivedValue: the value emitted by the Publisher
    ///
    init(demand: Int,
         onValueReceived: @escaping (_ receivedValue: T) -> Int = { _ in return 0 },
         onComplete: @escaping (_ receivedValues: [T]) -> Void) {
        self.demand = demand
        self.onComplete = onComplete
        self.onValueReceived = onValueReceived
    }
    
    /// This method will request the specified amount of values from the Publisher
    /// - Parameter demand: the amount of values to demand from the Publisher
    ///
    /// Use this method to increase the initial demand:
    /// ```
    /// // Initial demand is 0
    /// let subscriber = TestSubscriber<TimeInterval>(demand: 0) { values in
    ///     // ...
    /// }
    /// // ...
    /// // The subscriber will request a single value from the Publisher
    /// subscriber.startRequestingValues(1)
    /// ```
    ///
    func startRequestingValues(_ demand: Int) {
        guard let subscription = subscription else {
            fatalError("requestValues(_:) may only be called after subscribing")
        }
        subscription.request(.max(demand))
    }
    
    func receive(subscription: Subscription) {
        // It's the Subscriber's responsibility to retain the Subscription to keep it from being deallocated.
        self.subscription = subscription
        subscription.request(.max(demand))
    }
    
    func receive(_ input: T) -> Subscribers.Demand {
        receivedValues.append(input)
        let newDemand = onValueReceived(input)
        return .max(newDemand)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        onComplete(receivedValues)
        // If the Subscription completes, the Subscriber must nil out its reference to it so that it can be released from memory.
        subscription = nil
    }
}
