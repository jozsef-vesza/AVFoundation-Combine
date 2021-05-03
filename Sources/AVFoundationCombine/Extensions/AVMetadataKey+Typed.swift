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
    
    /// Common `AVMetadataKey` that can safely assume to have a `String` value in an `AVAsset`'s `commonMetadata` entry.
    enum StringValueKey: AVMetadataKeyConvertible {
        
        case title
        case creator
        case subject
        case description
        case publisher
        case contributor
        case type
        case format
        case identifier
        case source
        case language
        case relation
        case location
        case copyrights
        case albumName
        case author
        case artist
        case make
        case model
        case software
        
        func toAVMetadataKey() -> AVMetadataKey {
            switch self {
            case .albumName:
                return .commonKeyAlbumName
            case .artist:
                return .commonKeyArtist
            case .author:
                return .commonKeyAuthor
            case .creator:
                return .commonKeyCreator
            case .copyrights:
                return .commonKeyCopyrights
            case .description:
                return .commonKeyDescription
            case .language:
                return .commonKeyLanguage
            case .publisher:
                return .commonKeyPublisher
            case .subject:
                return .commonKeySubject
            case .title:
                return .commonKeyTitle
            case .contributor:
                return .commonKeyContributor
            case .type:
                return .commonKeyType
            case .format:
                return .commonKeyFormat
            case .identifier:
                return .commonKeyIdentifier
            case .source:
                return .commonKeySource
            case .relation:
                return .commonKeyRelation
            case .location:
                return .commonKeyLocation
            case .make:
                return .commonKeyMake
            case .model:
                return .commonKeyModel
            case .software:
                return .commonKeySoftware
            }
        }
    }
}
