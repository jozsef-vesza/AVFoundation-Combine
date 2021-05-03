//
//  AVPlayerMetadataKey+Typed.swift
//  AVFoundation-Combine
//
//  Created by Juan Carlos Ospina Gonzalez on 30/04/2021.
//

import Foundation
import Combine
import AVKit

protocol AVMetadataKeyConvertible {
    func toAVMetadataKey() -> AVMetadataKey
}

public extension AVMetadataKey {
    
    /// `AVMetadataKey` that can safely assume to have a `Data` value containing an image,  in an `AVAsset`'s `commonMetadata` entry.
    enum ImageValueKey: AVMetadataKeyConvertible {
        
        case commonKeyArtwork
        
        func toAVMetadataKey() -> AVMetadataKey {
            switch self {
            case .commonKeyArtwork:
                return .commonKeyArtwork
            }
        }
    }
    
    /// `AVMetadataKey` that can safely assume to have a `String` value in an `AVAsset`'s `commonMetadata` entry.
    enum StringValueKey: AVMetadataKeyConvertible {
        
        case commonKeyAlbumName
        case commonKeyArtist
        case commonKeyAuthor
        case commonKeyCreator
        case commonKeyCopyrights
        case commonKeyDescription
        case commonKeyLanguage
        case commonKeyPublisher
        case commonKeyTitle
        
        func toAVMetadataKey() -> AVMetadataKey {
            switch self {
            case .commonKeyAlbumName:
                return .commonKeyAlbumName
            case .commonKeyArtist:
                return .commonKeyArtist
            case .commonKeyAuthor:
                return .commonKeyAuthor
            case .commonKeyCreator:
                return .commonKeyCreator
            case .commonKeyCopyrights:
                return .commonKeyCopyrights
            case .commonKeyDescription:
                return .commonKeyDescription
            case .commonKeyLanguage:
                return .commonKeyLanguage
            case .commonKeyPublisher:
                return .commonKeyPublisher
            case .commonKeyTitle:
                return .commonKeyTitle
            }
        }
    }
}
