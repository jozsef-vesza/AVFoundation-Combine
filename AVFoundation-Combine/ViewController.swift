//
//  ViewController.swift
//  AVFoundation-Combine
//
//  Created by József Vesza on 2020. 07. 16..
//  Copyright © 2020. József Vesza. All rights reserved.
//

import UIKit
import AVKit

import Combine

class ViewController: AVPlayerViewController {
    
    /// A sample video URL
    private let videoURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
    
    /// A set to store all our Publisher susbcriptions
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let player = AVPlayer()
        
        player.currentItemPublisher()
            .sink { item in
                print(">> current item: \(String(describing: item))")
            }
            .store(in: &subscriptions)
        
        player.playheadProgressPublisher()
            .sink { (time) in
                print(">> received playhead progress: \(time)")
            }
            .store(in: &subscriptions)

        player.statusPublisher()
            .sink { status in
                print("received status:")
                switch status {
                case .unknown:
                    print(">> unknown")
                case .readyToPlay:
                    print(">> ready to play")
                case .failed:
                    print(">> failed")
                @unknown default:
                    print(">> other")
                }
            }
            .store(in: &subscriptions)

        player.ratePublisher()
            .sink { (rate) in
                print("rate changed:")
                switch rate {
                case 0.0:
                    print(">> paused")
                case 1.0:
                    print(">> playing")
                default:
                    print(">> \(rate)")
                }
            }
            .store(in: &subscriptions)

        player.isPlaybackLikelyToKeepUpPublisher()
            .sink {isPlaybackLikelyToKeepUp in
                print(">> isPlaybackLikelyToKeepUp \(isPlaybackLikelyToKeepUp) ")
            }
            .store(in: &subscriptions)
        
        // Load our sample video
        player.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
        self.player = player
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player?.play()
    }
}
