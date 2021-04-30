//
//  ViewController.swift
//  AVFoundation-Combine
//
//  Created by József Vesza on 2020. 07. 16..
//

import UIKit
import AVKit

import Combine

class VideoPlayerViewController: AVPlayerViewController {
    
    /// A sample video URL
    ///
    /// **Big Buck Bunny (2008)**
    ///
    /// A recently awoken enormous and utterly adorable fluffy rabbit is heartlessly harassed by a flying squirrel's gang of rodents who are determined to squash his happiness.
    private let videoURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
    
    /// A `Set` to store all our `Publisher` susbcriptions
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player = AVPlayer()
        
        player?.currentItemPublisher()
            .sink {[weak self] item in
                print(">> current item: \(String(describing: item))")
                if item != nil {
                    self?.subscribeToPlayerItemPublishers()
                }
        }
        .store(in: &subscriptions)
        
        player?.playheadProgressPublisher()
            .sink { (time) in
                print(">> received playhead progress: \(time)")
        }
        .store(in: &subscriptions)
        
        player?.ratePublisher()
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
        
        // Load our sample video
        player?.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
        
    }
    
    private func subscribeToPlayerItemPublishers() {
        player?.isPlaybackLikelyToKeepUpPublisher()
            .sink {isPlaybackLikelyToKeepUp in
                print(">> isPlaybackLikelyToKeepUp \(isPlaybackLikelyToKeepUp) ")
        }
        .store(in: &subscriptions)
        
        player?.isPlaybackBufferEmptyPublisher()
            .sink {isPlaybackBufferEmpty in
                print(">> isPlaybackBufferEmpty \(isPlaybackBufferEmpty) ")
        }
        .store(in: &subscriptions)
        
        player?.statusPublisher()
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player?.play()
    }
}
