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

class VideoPlayerViewController: AVPlayerViewController {
    
    /// A sample video URL
    ///
    /// **Big Buck Bunny (2008)**
    ///
    /// A recently awoken enormous and utterly adorable fluffy rabbit is heartlessly harassed by a flying squirrel's gang of rodents who are determined to squash his happiness.
    private let videoURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
    
    /// A `Set` to store all our `Publisher` susbcriptions
    private var subscriptions = Set<AnyCancellable>()
    
    /// Logo image on the top left corner. In this example, it will become semi-transparent when `AVPlayerItem.status == .readyToPlay`
    private var logoImageView: UIImageView!
    
    // MARK: UI setup
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "Background")
        showsPlaybackControls = false
        guard let contentOverlayView = contentOverlayView else {
            fatalError("`contentOverlayView` is required.")
        }
        
        // Logo image on the top left corner
        logoImageView = UIImageView(image: UIImage(named: "AVLogo"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        contentOverlayView.addSubview(logoImageView)
        logoImageView.topAnchor.constraint(equalTo: contentOverlayView.safeAreaLayoutGuide.topAnchor, constant: 20.0).isActive = true
        logoImageView.leadingAnchor.constraint(equalTo: contentOverlayView.safeAreaLayoutGuide.leadingAnchor, constant: 20.0).isActive = true
        
    }
    
    // MARK: Video Player setup
    
    private func setupAVPlayer() {
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
            .sink { [weak self] status in
                print("received status:")
                switch status {
                case .unknown:
                    print(">> unknown")
                case .readyToPlay:
                    print(">> ready to play")
                    self?.logoImageView.alpha = 0.5
                case .failed:
                    print(">> failed")
                @unknown default:
                    print(">> other")
                }
        }
        .store(in: &subscriptions)
    }
    
    // MARK: Lifecycle overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAVPlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player?.play()
    }
}
