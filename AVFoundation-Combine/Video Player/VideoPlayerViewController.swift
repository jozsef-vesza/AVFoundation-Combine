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

final class VideoPlayerViewController: AVPlayerViewController {
    
    /// A sample video URL
    ///
    /// **Big Buck Bunny (2008)**
    ///
    /// A recently awoken enormous and utterly adorable fluffy rabbit is heartlessly harassed by a flying squirrel's gang of rodents who are determined to squash his happiness.
    private let videoURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
    
    /// A `Set` to store all our `Publisher` susbcriptions
    private var subscriptions = Set<AnyCancellable>()
    
    /// A flag to keep track of whether the user is using `progressSlider` to scrub trough the video timeline. Used to prevent the thumb in the slider from jumping back and forth while `seek` is in progress.
    private var isProgressSliderScrubbing: Bool = false
    
    lazy private var customUI: VideoPlayerView = {
        VideoPlayerView()
    }()
    
    // MARK: UI setup
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "Background")
        showsPlaybackControls = false
        guard let contentOverlayView = contentOverlayView else {
            fatalError("`contentOverlayView` is required.")
        }
        customUI.translatesAutoresizingMaskIntoConstraints = false
        contentOverlayView.addSubview(customUI)
        [
            customUI.leadingAnchor.constraint(equalTo: contentOverlayView.leadingAnchor),
            customUI.trailingAnchor.constraint(equalTo: contentOverlayView.trailingAnchor),
            customUI.topAnchor.constraint(equalTo: contentOverlayView.topAnchor),
            customUI.bottomAnchor.constraint(equalTo: contentOverlayView.bottomAnchor),
        ].forEach { $0.isActive = true}
        
        customUI.playbackButton.addTarget(self, action: #selector(togglePlayback), for: .touchUpInside)
        
        customUI.progressSlider.addTarget(self, action: #selector(onSliderThumbTouchedDown), for: .touchDown)
        customUI.progressSlider.addTarget(self, action: #selector(onSliderThumbTouchedUp), for: .touchUpOutside)
        customUI.progressSlider.addTarget(self, action: #selector(onSliderThumbTouchedUp), for: .touchUpInside)
    }
    
    // MARK: UI Actions
    
    // MARK: Scubber
    
    @objc private func onSliderThumbTouchedDown() {
        isProgressSliderScrubbing = true
    }
    
    @objc private func onSliderThumbTouchedUp() {
        player?.seek(to: CMTime(seconds: Double(customUI.progressSlider.value), preferredTimescale: 1)) {[weak self] _ in
            self?.isProgressSliderScrubbing = false
        }
    }
    
    // MARK: Play / Pause button
    
    @objc private func togglePlayback() {
        player?.rate == 0.0 ? player?.play() : player?.pause()
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
            .sink {[weak self] (time) in
                print(">> received playhead progress: \(time)")
                guard let self = self else {
                    return
                }
                guard !self.isProgressSliderScrubbing else {
                    return
                }
                self.customUI.progressSlider.value = Float(time)
        }
        .store(in: &subscriptions)
        
        player?.ratePublisher()
            .sink {[weak self] (rate) in
                print("rate changed:")
                self?.customUI.playbackButton.accessibilityLabel = rate == 0.0 ? "Play" : "Pause"
                switch rate {
                case 0.0:
                    print(">> paused")
                    self?.customUI.playbackButton.setImage(UIImage(named: "Play"), for: .normal)
                case 1.0:
                    print(">> playing")
                    self?.customUI.playbackButton.setImage(UIImage(named: "Pause"), for: .normal)
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
            .sink {[weak self] isPlaybackLikelyToKeepUp in
                print(">> isPlaybackLikelyToKeepUp \(isPlaybackLikelyToKeepUp) ")
                guard let self = self else {
                    return
                }
                self.customUI.loadingIndicator.isHidden = true
        }
        .store(in: &subscriptions)
        
        player?.isPlaybackBufferEmptyPublisher()
            .sink {[weak self] isPlaybackBufferEmpty in
                print(">> isPlaybackBufferEmpty \(isPlaybackBufferEmpty) ")
                self?.customUI.loadingIndicator.isHidden = false
        }
        .store(in: &subscriptions)
        
        player?.statusPublisher()
            .sink { [weak self] status in
                print("received status:")
                self?.customUI.playbackButton.isEnabled = status == .readyToPlay
                self?.customUI.progressSlider.isEnabled = status == .readyToPlay
                self?.customUI.playbackButton.alpha = status == .readyToPlay ? 1.0 : 0.25
                self?.customUI.logoImageView.alpha = status == .readyToPlay ? 0.5 : 1.0
                switch status {
                case .unknown:
                    print(">> unknown")
                case .readyToPlay:
                    print(">> ready to play")
                    guard let item = self?.player?.currentItem else { return }
                    self?.customUI.progressSlider.maximumValue = Float(item.duration.seconds)
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
