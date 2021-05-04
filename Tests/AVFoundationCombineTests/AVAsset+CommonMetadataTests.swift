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
        sut.commonMetadataValuePublisher(stringValueKey: .title)
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
        sut.commonMetadataValuePublisher(stringValueKey: .albumName)
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
        sut.commonMetadataValuePublisher(stringValueKey: .artist)
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
        sut.commonMetadataValuePublisher(stringValueKey: .type)
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
        #if !os(macOS)
        // Given
        let sut = commonKeysTestAVAsset
        let testExpectation = expectation(description: "artwork should be found")
        // When
        sut.commonMetadataArtworkPublisher()
            .sink { value in
                // Then
                testExpectation.fulfill()
            }
            .store(in: &subscribers)
        
        wait(for: [testExpectation], timeout: 0.5)
        #endif
    }
    
    static var allTests = [
        ("testWhenAVAssetContainsMetadataCommonKeyTypeValue_StringValueIsEmitted", testWhenAVAssetContainsMetadataCommonKeyTypeValue_StringValueIsEmitted),
        ("testWhenAVAssetContainsMetadataCommonKeyArtistValue_StringValueIsEmitted", testWhenAVAssetContainsMetadataCommonKeyArtistValue_StringValueIsEmitted),
        ("testWhenAVAssetContainsMetadataCommonKeyAlbumNameValue_StringValueIsEmitted", testWhenAVAssetContainsMetadataCommonKeyAlbumNameValue_StringValueIsEmitted),
        ("testWhenAVAssetContainsMetadataCommonKeyTitleValue_StringValueIsEmitted", testWhenAVAssetContainsMetadataCommonKeyTitleValue_StringValueIsEmitted),
        ("testWhenAVAssetContainsMetadataCommonKeyArtworkValue_UIImageValueIsEmitted", testWhenAVAssetContainsMetadataCommonKeyArtworkValue_UIImageValueIsEmitted),
    ]
}
