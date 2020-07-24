//
//  TestSubscriber.swift
//  AVFoundation-CombineTests
//
//  Created by József Vesza on 2020. 07. 24..
//  Copyright © 2020. József Vesza. All rights reserved.
//

import Combine

class TestSubscriber<T>: Subscriber {
    typealias Input = T
    typealias Failure = Never
    
    let demand: Int
    let onComplete: ([T]) -> Void
    
    private var receivedValues: [T] = []
    private var subscription: Subscription? = nil
    
    init(demand: Int, onComplete: @escaping ([T]) -> Void) {
        self.demand = demand
        self.onComplete = onComplete
    }
    
    func receive(subscription: Subscription) {
        self.subscription = subscription
        subscription.request(.max(demand))
    }
    
    func receive(_ input: T) -> Subscribers.Demand {
        receivedValues.append(input)
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        onComplete(receivedValues)
        subscription = nil
    }
}
