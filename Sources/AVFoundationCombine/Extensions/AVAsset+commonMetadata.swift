//
//  AVPlayerItem+Publishers.swift
//  AVFoundation-Combine
//
//  Created by Juan Carlos Ospina Gonzalez on 30/04/2021.
//

import AVKit
import Combine
import Foundation
#if !os(macOS)
import UIKit
#endif

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
     - Parameter key: key of the `AVMetadataItem`
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
     - Parameter key: key of the `AVMetadataItem`
     - Returns: A `Publisher` that emits the extras of a specific `AVMetadataItem` matching a given `AVMetadataKey` (if it exists in the `AVAsset`'s `commonMetadata` entries).
     */
    func commonMetadataExtrasPublisher(key: AVMetadataKey) -> AnyPublisher<[AVMetadataExtraAttributeKey: Any], Never> {
        publisher(for: \.commonMetadata)
            .compactMap { metadata -> [AVMetadataExtraAttributeKey: Any]? in
                metadata.filter { $0.commonKey == key }.first?.extraAttributes
            }
            .eraseToAnyPublisher()
    }
    
    /**
     `Publisher` that emits the value of a `AVMetadataItem` matching a given `AVMetadataKey` (if it exists in the `AVAsset`'s `commonMetadata` entries) casting said value to a given concrete type.
     
      This will only succeed if the  `AVMetadataItem` matching a given `AVMetadataKey` exists and casting its value to the concrete value succeeds.
     
      The following example retrieves value of the `AVMetadataItem` `.commonKeyTitle` key whose value can safely be assumed to be `String`.
     
     ```
     asset.commonMetadataValuePublisher(key: .commonKeyTitle, as: String.self)
         .receive(on: DispatchQueue.main)
         .sink { title in
             print("the title is \(title)") // title is a String
         }
         .store(in: &subscriptions)
     ```
     - Parameter key: key of the `AVMetadataItem`
     - Parameter as: the concrete type to cast the `AVMetadataItem`'s value to (if found)
     - Returns: A `Publisher` that emits the value `AVMetadataItem` matching a given `AVMetadataKey` (if it exists in the `AVAsset`'s `commonMetadata` entries) casting said value to a given concrete type.
     */
    func commonMetadataValuePublisher<T>(key: AVMetadataKey, as: T.Type) -> AnyPublisher<T, Never> {
        publisher(for: \.commonMetadata)
            .compactMap { metadata -> T? in
                metadata.filter { $0.commonKey == key }.first?.value as? T
            }
            .eraseToAnyPublisher()
    }
    
    /**
     `Publisher` that emits the `String` value of a `AVMetadataItem` matching a given `AVMetadataKey.StringValueKey`, if it exists in the `AVAsset`'s `commonMetadata` entries.
     
     This will only succeed if the  `AVMetadataItem` matching a given `AVMetadataKey.StringValueKey` converted to a `AVMetadataKey` exists and casting its value to `String` succeeds.
     
     The following example retrieves `.commonKeyTitle` value in an `AVAsset` which can be safely assumed to be a `String`.
     
     ```
     asset.commonMetadataValuePublisher(stringValueKey: .commonKeyTitle)
         .receive(on: DispatchQueue.main)
         .sink { title in
             print("the title is \(title)") // title is a String
         }
         .store(in: &subscriptions)
     ```
     - Parameter tringValueKey: one of the keys in `AVMetadataKey.StringValueKey` which maps to a known `AVMetadataKey`
     - returns: `Publisher` that emits the `String` value of a `AVMetadataItem` matching a given `AVMetadataKey.StringValueCommonKey`, if it exists in the `AVAsset`'s `commonMetadata` entries.
     - seeAlso: `AVMetadataKey.StringValueKey`
     */
    func commonMetadataValuePublisher(stringValueKey key: AVMetadataKey.StringValueKey) -> AnyPublisher<String, Never> {
        commonMetadataValuePublisher(key: key.toAVMetadataKey(), as: String.self)
    }
    
    #if !os(macOS)
    
    /**
     `Publisher` that emits the `UIImage` value of a `AVMetadataItem` matching a given `AVMetadataKey.ImageValueKey`, if it exists in the `AVAsset`'s `commonMetadata` entries.
     
     This will only succeed if the  `AVMetadataItem` matching a given `AVMetadataKey.ImageValueKey` converted to a `AVMetadataKey` exists and converting  its `Data` value to `UIImage` succeeds.
     
     The following example retrieves `.commonKeyArtwork` value in an `AVAsset` which can be safely assumed to be a `Data` encoding an image ( represented as `UIImage`).
     
     ```
     asset.commonMetadataValuePublisher(imageValueKey: .commonKeyArtwork)
         .receive(on: DispatchQueue.main)
         .sink { image in
             // do something with the image
         }
         .store(in: &subscriptions)
     ```
     - Parameter imageValueKey: one of the keys in `AVMetadataKey.UIImageValueCommonKey` which maps to a known `AVMetadataKey`
     - returns: a `Publisher` that emits the `UIImage` value of a `AVMetadataItem` matching a given `AVMetadataKey.UIImageValueCommonKey`, if it exists in the `AVAsset`'s `commonMetadata` entries.
     - seeAlso: `AVMetadataKey.ImageValueKey`
     */
    func commonMetadataValuePublisher(imageValueKey key: AVMetadataKey.ImageValueKey) -> AnyPublisher<UIImage, Never> {
        commonMetadataValuePublisher(key: key.toAVMetadataKey(), as: Data.self)
            .compactMap { data -> UIImage? in
                return UIImage(data: data)
            }
            .eraseToAnyPublisher()
    }
    
    #endif
    
}
