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
        
        case commonKeyTitle
        case commonKeyCreator
        case commonKeySubject
        case commonKeyDescription
        case commonKeyPublisher
        case commonKeyContributor
        case commonKeyType
        case commonKeyFormat
        case commonKeyIdentifier
        case commonKeySource
        case commonKeyLanguage
        case commonKeyRelation
        case commonKeyLocation
        case commonKeyCopyrights
        case commonKeyAlbumName
        case commonKeyAuthor
        case commonKeyArtist
        case commonKeyMake
        case commonKeyModel
        case commonKeySoftware
        
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
            case .commonKeySubject:
                return .commonKeySubject
            case .commonKeyTitle:
                return .commonKeyTitle
            case .commonKeyContributor:
                return .commonKeyContributor
            case .commonKeyType:
                return .commonKeyType
            case .commonKeyFormat:
                return .commonKeyFormat
            case .commonKeyIdentifier:
                return .commonKeyIdentifier
            case .commonKeySource:
                return .commonKeySource
            case .commonKeyRelation:
                return .commonKeyRelation
            case .commonKeyLocation:
                return .commonKeyLocation
            case .commonKeyMake:
                return .commonKeyMake
            case .commonKeyModel:
                return .commonKeyModel
            case .commonKeySoftware:
                return .commonKeySoftware
            }
        }
    }
}
