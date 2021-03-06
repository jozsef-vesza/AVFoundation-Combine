//
//  ViewController.swift
//  AVFoundation-Combine
//
//  Created by József Vesza on 2020. 07. 16..
//  Copyright © 2020. József Vesza. All rights reserved.
//

// System
import AVKit
import Combine
import UIKit

// Third Party
import AVFoundationCombine

final class VideoPlayerViewController: UIViewController {
    
    /// A sample video URL
    ///
    /// **Big Buck Bunny (2008)**
    ///
    /// A recently awoken enormous and utterly adorable fluffy rabbit is heartlessly harassed by a flying squirrel's gang of rodents who are determined to squash his happiness.
    private let videoURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
    
    /// A `Set` to store all our `Publisher` susbcriptions
    private var subscriptions = Set<AnyCancellable>()
    
    /// A flag to keep track of whether the user is actioning `progressSlider` to scrub trough the video timeline. Used to prevent the thumb in the slider from jumping back and forth while `seek` is in progress.
    private var isProgressSliderScrubbing: Bool = false
    
    /// A flag that is updated by a subcription to `AVPlayer.rate`. Its main function is to decide wheter to `play()` or `pause()` when the user taps the play/pause button
    private var isPlaying: Bool = false
    
    /// Reference to the AVPlayer instance used to support replaying
    private var player: AVPlayer!
    
    /// A view with custom controls
    lazy private var videoPlayerContentOverlay: VideoPlayerContentOverlay = {
        VideoPlayerContentOverlay()
    }()
    
    lazy private var avPlayerViewController: AVPlayerViewController = {
        AVPlayerViewController()
    }()

    // MARK: - Overrides
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        [videoPlayerContentOverlay.playbackButton]
    }
    
    // MARK: - Lifecycle overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setup(AVPlayer())
    }
    
    // MARK: - UI setup
    
    private func setupUI() {
        addChild(avPlayerViewController)

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
        videoPlayerContentOverlay.playbackButton.addTarget(self, action: #selector(togglePlayback), for: .primaryActionTriggered)
        #if os(iOS)
        videoPlayerContentOverlay.progressSlider.addTarget(self, action: #selector(onSliderThumbTouchedDown), for: .touchDown)
        videoPlayerContentOverlay.progressSlider.addTarget(self, action: #selector(onSliderThumbTouchedUp), for: .touchUpOutside)
        videoPlayerContentOverlay.progressSlider.addTarget(self, action: #selector(onSliderThumbTouchedUp), for: .touchUpInside)
        #endif
    }
    
    // MARK: - UI Actions
    
    // MARK: - Scubber

    #if os(iOS)
    @objc private func onSliderThumbTouchedDown() {
        isProgressSliderScrubbing = true
    }
    
    @objc private func onSliderThumbTouchedUp() {
        avPlayerViewController.player?.seek(to: CMTime(seconds: Double(videoPlayerContentOverlay.progressSlider.value), preferredTimescale: 1)) { [weak self] _ in
            self?.isProgressSliderScrubbing = false
        }
    }
    #endif
    // MARK: - Play / Pause button
    
    @objc private func togglePlayback() {
        isPlaying ? avPlayerViewController.player?.pause() : avPlayerViewController.player?.play()
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
        #if os(iOS)
        player.playheadProgressPublisher()
            .filter {progress in
                !self.isProgressSliderScrubbing
            }
            .map { Float($0) }
            .assign(to: \.value, on: videoPlayerContentOverlay.progressSlider)
            .store(in: &subscriptions)
        #endif
        
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

        #if os(iOS)
        statusStream.receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: videoPlayerContentOverlay.progressSlider)
            .store(in: &subscriptions)
        #endif
        
        statusStream.receive(on: DispatchQueue.main)
            .map { $0 ? 1.0 : 0.25 }
            .assign(to: \.alpha, on: videoPlayerContentOverlay.playbackButton)
            .store(in: &subscriptions)
        
        statusStream.receive(on: DispatchQueue.main)
            .map { $0 ? 0.5 : 1.0 }
            .assign(to: \.alpha, on: videoPlayerContentOverlay.logoImageView)
            .store(in: &subscriptions)

        #if os(iOS)
        item.durationPublisher()
            .map { $0.isNumeric ? Float($0.seconds) : 0.0 }
            .removeDuplicates()
            .assign(to: \.maximumValue, on: videoPlayerContentOverlay.progressSlider)
            .store(in: &subscriptions)
        #endif
        
        item.didPlayToEndTimePublisher()
            .sink { [weak self] _ in
                #if os(iOS)
                self?.videoPlayerContentOverlay.progressSlider.isHidden = true
                #endif
                self?.avPlayerViewController.player?.seek(to: CMTime(seconds: 0, preferredTimescale: 60))
            }
            .store(in: &subscriptions)
    }
}
