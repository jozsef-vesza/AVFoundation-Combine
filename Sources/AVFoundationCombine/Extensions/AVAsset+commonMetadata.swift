//
//  AVPlayerItem+Publishers.swift
//  AVFoundation-Combine
//
//  Created by Juan Carlos Ospina Gonzalez on 17/07/2020.
//  Copyright © 2020 József Vesza. All rights reserved.
//

import Foundation
import Combine
import AVKit

public extension AVAsset {
    /**
     `Publisher` that emits a specific `AVMetadataItem` matching a given `AVMetadataKey` (if it exists in the `AVAsset`.
     
     The following example retrieves the `AVMetadataItem` for the `.commonKeyTitle` if it exists in the `AVAsset`
     
     ```
     asset.commonMetadataPublisher(key: .commonKeyTitle)
         .receive(on: DispatchQueue.main)
         .sink { title in
             print("the title is \(title.value)")
         }
         .store(in: &subscriptions)
     ```
     - Parameter key: common key of the `AVMetadataItem`
     - Returns: A `Publisher` that emits a specific `AVMetadataItem` with a given `AVMetadataKey` (if it exists in the `AVAsset`.
     */
    func commonMetadataPublisher(key: AVMetadataKey) -> AnyPublisher<AVMetadataItem, Never> {
        publisher(for: \.commonMetadata)
            .compactMap { metadata -> AVMetadataItem? in
                metadata.filter { $0.commonKey == key }.first
            }
            .eraseToAnyPublisher()
    }
    
}
