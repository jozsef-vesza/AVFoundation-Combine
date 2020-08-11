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

final class VideoPlayerViewController: UIViewController {
    
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
    
    private var isPlaying: Bool = false
    
    /// Reference to the AVPlayer instance used to support replaying
    private var player: AVPlayer!
    
    lazy private var videoPlayerContentOverlay: VideoPlayerContentOverlay = {
        VideoPlayerContentOverlay()
    }()
    
    lazy private var avPlayerViewController: AVPlayerViewController = {
        AVPlayerViewController()
    }()
    
    // MARK: - Lifecycle overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setup(AVPlayer())
    }
    
    // MARK: - UI setup
    
    private func setupUI() {
        addChild(avPlayerViewController)
        avPlayerViewController.entersFullScreenWhenPlaybackBegins = true
        view.addSubviewAndFillBounds(avPlayerViewController.view)
        avPlayerViewController.didMove(toParent: self)
        avPlayerViewController.view.backgroundColor = UIColor(named: "Background")
        avPlayerViewController.showsPlaybackControls = false
        guard let contentOverlayView = avPlayerViewController.contentOverlayView else {
            fatalError("`contentOverlayView` is required.")
        }
        contentOverlayView.addSubviewAndFillBounds(videoPlayerContentOverlay)
        videoPlayerContentOverlay.translatesAutoresizingMaskIntoConstraints = false
        videoPlayerContentOverlay.playbackButton.addTarget(self, action: #selector(togglePlayback), for: .touchUpInside)
        videoPlayerContentOverlay.progressSlider.addTarget(self, action: #selector(onSliderThumbTouchedDown), for: .touchDown)
        videoPlayerContentOverlay.progressSlider.addTarget(self, action: #selector(onSliderThumbTouchedUp), for: .touchUpOutside)
        videoPlayerContentOverlay.progressSlider.addTarget(self, action: #selector(onSliderThumbTouchedUp), for: .touchUpInside)
        videoPlayerContentOverlay.replayButton.addTarget(self, action: #selector(replay), for: .touchUpInside)
    }
    
    // MARK: - UI Actions
    
    // MARK: - Scubber
    
    @objc private func onSliderThumbTouchedDown() {
        isProgressSliderScrubbing = true
    }
    
    @objc private func onSliderThumbTouchedUp() {
        avPlayerViewController.player?.seek(to: CMTime(seconds: Double(videoPlayerContentOverlay.progressSlider.value), preferredTimescale: 1)) { [weak self] _ in
            self?.isProgressSliderScrubbing = false
        }
    }
    
    // MARK: - Play / Pause button
    
    @objc private func togglePlayback() {
        isPlaying ? avPlayerViewController.player?.pause() : avPlayerViewController.player?.play()
    }
    
    // MARK: - Replay button
    
    @objc private func replay() {
        videoPlayerContentOverlay.replayOverlay.isHidden = true
        videoPlayerContentOverlay.progressSlider.isHidden = false
        videoPlayerContentOverlay.playbackButton.isHidden = false
        player.seek(to: CMTime.zero)
        player.play()
    }
    
    // MARK: - Video Player setup
    
    private func setup(_ player: AVPlayer) {
        self.player = player
        player.currentItemPublisher()
            .compactMap { $0 }
            .sink {[weak self] item in
                self?.setup(item)
                self?.avPlayerViewController.player?.play()
            }
            .store(in: &subscriptions)
        
        player.playheadProgressPublisher()
            .filter {progress in
                !self.isProgressSliderScrubbing
            }
            .map { Float($0) }
            .assign(to: \.value, on: videoPlayerContentOverlay.progressSlider)
            .store(in: &subscriptions)
        
        let rateStream = player.ratePublisher()
            .receive(on: DispatchQueue.main)
            .share()
        
        rateStream
            .map { $0 == 1.0 }
            .assign(to: \.isPlaying, on: self)
            .store(in: &subscriptions)
        
        rateStream
            .map { $0 == 0.0 ? "Play" : "Pause" }
            .assign(to: \.accessibilityLabel, on: videoPlayerContentOverlay.playbackButton)
            .store(in: &subscriptions)
        
        rateStream
            .map { $0 == 0.0 ? UIImage(named: "Play") : UIImage(named: "Pause") }
            .sink {[weak self] image in
                self?.videoPlayerContentOverlay.playbackButton.setImage(image, for: .normal)
            }
            .store(in: &subscriptions)
        
        avPlayerViewController.player = player
        player.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
    }
    
    private func setup(_ item: AVPlayerItem) {
        
        item.isPlaybackLikelyToKeepUpPublisher()
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .assign(to: \.isHidden, on: videoPlayerContentOverlay.loadingIndicator)
            .store(in: &subscriptions)
        
        item.isPlaybackBufferEmptyPublisher()
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .map { !$0 }
            .assign(to: \.isHidden, on: videoPlayerContentOverlay.loadingIndicator)
            .store(in: &subscriptions)
        
        let statusStream = item.statusPublisher().share()
            .map { $0 == .readyToPlay }
        
        statusStream.receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: videoPlayerContentOverlay.playbackButton)
            .store(in: &subscriptions)
        
        statusStream.receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: videoPlayerContentOverlay.progressSlider)
            .store(in: &subscriptions)
        
        statusStream.receive(on: DispatchQueue.main)
            .map { $0 ? 1.0 : 0.25 }
            .assign(to: \.alpha, on: videoPlayerContentOverlay.playbackButton)
            .store(in: &subscriptions)
        
        statusStream.receive(on: DispatchQueue.main)
            .map { $0 ? 0.5 : 1.0 }
            .assign(to: \.alpha, on: videoPlayerContentOverlay.logoImageView)
            .store(in: &subscriptions)
        
        item.durationPublisher()
            .map { $0.isNumeric ? Float($0.seconds) : 0.0 }
            .removeDuplicates()
            .assign(to: \.maximumValue, on: videoPlayerContentOverlay.progressSlider)
            .store(in: &subscriptions)
        
        item.didPlayToEndTimePublisher()
            .sink { [weak self] _ in
                self?.videoPlayerContentOverlay.progressSlider.isHidden = true
                self?.videoPlayerContentOverlay.playbackButton.isHidden = true
                self?.videoPlayerContentOverlay.replayOverlay.isHidden = false
            }
            .store(in: &subscriptions)
    }
}
