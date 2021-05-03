//
//  AVAsset+CommonMetadataTests.swift
//  AVFoundation-CombineTests
//
//  Created by Juan Carlos Ospina Gonzalez on 03/05/2021.
//

import XCTest
import Combine
import AVFoundation

@testable import AVFoundationCombine

class AVAsset_CommonMetadataPublisherTests: XCTestCase {
    
    private var subscribers = Set<AnyCancellable>()
    
    // MARK: Private helper functions
    
    private var commonKeysTestAVAsset: AVAsset {
        guard let path = Bundle.module.path(forResource: "commonKeysSample", ofType: "mp3") else {
            fatalError("Test target should contain commonKeysSample.mp3")
        }
        return AVAsset(url: URL(fileURLWithPath: path))
    }
    
    // MARK: Overrides
    
    override func setUp() {
        subscribers = Set<AnyCancellable>()
    }
    
    // MARK: Tests
    
    func testWhenAVAssetContainsMetadataCommonKeyTitleValue_StringValueIsEmitted() {
        // Given
        let sut = commonKeysTestAVAsset
        let testExpectation = expectation(description: "title should be found")
        // When
        sut.commonMetadataValuePublisher(stringValueKey: .commonKeyTitle)
            .sink { value in
                // Then
                if value == "AVFoundationCombine Test Track" {
                    testExpectation.fulfill()
                }
            }
            .store(in: &subscribers)
        
        wait(for: [testExpectation], timeout: 0.5)
    }
    
    func testWhenAVAssetContainsMetadataCommonKeyAlbumNameValue_StringValueIsEmitted() {
        // Given
        let sut = commonKeysTestAVAsset
        let testExpectation = expectation(description: "album to title should be found")
        // When
        sut.commonMetadataValuePublisher(stringValueKey: .commonKeyAlbumName)
            .sink { value in
                // Then
                if value == "AVFoundationCombine Test Tracks" {
                    testExpectation.fulfill()
                }
            }
            .store(in: &subscribers)
        
        wait(for: [testExpectation], timeout: 0.5)
    }
    
    func testWhenAVAssetContainsMetadataCommonKeyArtistValue_StringValueIsEmitted() {
        // Given
        let sut = commonKeysTestAVAsset
        let testExpectation = expectation(description: "artist should be found")
        // When
        sut.commonMetadataValuePublisher(stringValueKey: .commonKeyArtist)
            .sink { value in
                // Then
                if value == "Juan Carlos Ospina Gonzalez" {
                    testExpectation.fulfill()
                }
            }
            .store(in: &subscribers)
        
        wait(for: [testExpectation], timeout: 0.5)
    }
    
    func testWhenAVAssetContainsMetadataCommonKeyTypeValue_StringValueIsEmitted() {
        // Given
        let sut = commonKeysTestAVAsset
        let testExpectation = expectation(description: "type should be found")
        // When
        sut.commonMetadataValuePublisher(stringValueKey: .commonKeyType)
            .sink { value in
                // Then
                if value == "Noise" {
                    testExpectation.fulfill()
                }
            }
            .store(in: &subscribers)
        
        wait(for: [testExpectation], timeout: 0.5)
    }
    
    func testWhenAVAssetContainsMetadataCommonKeyArtworkValue_UIImageValueIsEmitted() {
        // Given
        let sut = commonKeysTestAVAsset
        let testExpectation = expectation(description: "artwork should be found")
        // When
        sut.commonMetadataValuePublisher(imageValueKey: .commonKeyArtwork)
            .sink { value in
                // Then
                testExpectation.fulfill()
            }
            .store(in: &subscribers)
        
        wait(for: [testExpectation], timeout: 0.5)
    }
}
