//
//  AVPlayerItem+Publishers.swift
//  AVFoundation-Combine
//
//  Created by Juan Carlos Ospina Gonzalez on 30/04/2021.
//

import Foundation
import Combine
import AVKit

public extension AVAsset {
    /**
     `Publisher` that emits a specific `AVMetadataItem` matching a given `AVMetadataKey` (if it exists in the `AVAsset`'s `commonMetadata` entries).
     
     The following example retrieves the `AVMetadataItem` for the `.commonKeyTitle` key if it exists in the `AVAsset`
     
     ```
     asset.commonMetadataPublisher(key: .commonKeyTitle)
         .receive(on: DispatchQueue.main)
         .sink { title in
             print("the title is \(title.value)")
         }
         .store(in: &subscriptions)
     ```
     - Parameter key: common key of the `AVMetadataItem`
     - Returns: A `Publisher` that emits a specific `AVMetadataItem` with a given `AVMetadataKey` (if it exists in the `AVAsset`'s `commonMetadata` entries).
     */
    func commonMetadataPublisher(key: AVMetadataKey) -> AnyPublisher<AVMetadataItem, Never> {
        publisher(for: \.commonMetadata)
            .compactMap { metadata -> AVMetadataItem? in
                metadata.filter { $0.commonKey == key }.first
            }
            .eraseToAnyPublisher()
    }
    
    /**
     `Publisher` that emits the extras of a specific `AVMetadataItem` matching a given `AVMetadataKey` (if it exists in the `AVAsset`'s `commonMetadata` entries).
     
     The following example retrieves the `AVMetadataItem`'s extras  for the `.commonKeyArtwork` key if it exists in the `AVAsset`
     
     ```
     asset.commonMetadataExtrasPublisherkey: .commonKeyArtwork)
         .receive(on: DispatchQueue.main)
         .sink { extras in
             print("the .commonKeyArtwork has the extras: \(extras)")
         }
         .store(in: &subscriptions)
     ```
     - Parameter key: common key of the `AVMetadataItem`
     - Returns: A `Publisher` that emits the extras of a specific `AVMetadataItem` matching a given `AVMetadataKey` (if it exists in the `AVAsset`'s `commonMetadata` entries).
     */
    func commonMetadataExtrasPublisher(key: AVMetadataKey) -> AnyPublisher<[AVMetadataExtraAttributeKey: Any], Never> {
        publisher(for: \.commonMetadata)
            .compactMap { metadata -> [AVMetadataExtraAttributeKey: Any]? in
                metadata.filter { $0.commonKey == key }.first?.extraAttributes
            }
            .eraseToAnyPublisher()
    }
    
}
