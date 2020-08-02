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
    
    /// Logo image on the top left corner. In this example, it becomes semi-transparent when `AVPlayerItem.status == .readyToPlay`
    private var logoImageView: UIImageView!
    
    /// Button that toggles playback. In this example, it changes its image and accessibility label based on `AVPlayer.rate`
    private var playbackButton: UIButton!
    
    /// Image that indicates the video is loading or buffering, it changes its visibility based on `AVPlayerItem.isPlaybackLikelyToKeepUp` and `AVPlayerItem.isPlaybackBufferEmpty`
    private var loadingIndicator: UIImageView!
    
    /// This slider acts as the playback progress indication, its value is updated by observing `AVPlayer.playheadProgressPublisher`
    private var progressSlider: UISlider!
    
    private var isProgressSliderScrubbing: Bool = false
    
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
        
        // Playback Button
        playbackButton = UIButton(type: .custom)
        playbackButton.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        playbackButton.layer.cornerRadius = 20.0
        playbackButton.layer.masksToBounds = true
        playbackButton.tintColor = .white
        playbackButton.translatesAutoresizingMaskIntoConstraints = false
        contentOverlayView.addSubview(playbackButton)
        playbackButton.bottomAnchor.constraint(equalTo: contentOverlayView.safeAreaLayoutGuide.bottomAnchor, constant: -20.0).isActive = true
        playbackButton.leadingAnchor.constraint(equalTo: contentOverlayView.safeAreaLayoutGuide.leadingAnchor, constant: 20.0).isActive = true
        playbackButton.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        playbackButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        playbackButton.addTarget(self, action: #selector(togglePlayback), for: .touchUpInside)
        
        // Loading indicator
        loadingIndicator = UIImageView(image: UIImage(named: "Loading"))
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentOverlayView.addSubview(loadingIndicator)
        loadingIndicator.centerYAnchor.constraint(equalTo: contentOverlayView.centerYAnchor).isActive = true
        loadingIndicator.centerXAnchor.constraint(equalTo: contentOverlayView.centerXAnchor).isActive = true
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = (Double.pi * 2)
        animation.duration = 0.5
        animation.repeatCount = Float.infinity
        loadingIndicator.layer.add(animation, forKey: "rotation")
        
        // Progress indicator
        progressSlider = UISlider()
        progressSlider.tintColor = UIColor(named: "Red")
        progressSlider.setThumbImage(UIImage(named: "Thumb"), for: .normal)
        progressSlider.addTarget(self, action: #selector(onSliderThumbTouchedDown), for: .touchDown)
        progressSlider.addTarget(self, action: #selector(onSliderThumbTouchedUp), for: .touchUpOutside)
        progressSlider.addTarget(self, action: #selector(onSliderThumbTouchedUp), for: .touchUpInside)
        progressSlider.translatesAutoresizingMaskIntoConstraints = false
        contentOverlayView.addSubview(progressSlider)
        progressSlider.leadingAnchor.constraint(equalTo: playbackButton.trailingAnchor, constant: 20.0).isActive = true
        progressSlider.trailingAnchor.constraint(equalTo: contentOverlayView.safeAreaLayoutGuide.trailingAnchor, constant: -20.0).isActive = true
        progressSlider.centerYAnchor.constraint(equalTo: playbackButton.centerYAnchor, constant: 0.0).isActive = true
    }
    
    // MARK: Actions
    
    @objc private func onSliderThumbTouchedDown() {
        isProgressSliderScrubbing = true
    }
    
    @objc private func onSliderThumbTouchedUp() {
        player?.seek(to: CMTime(seconds: Double(progressSlider.value), preferredTimescale: 1)) {[weak self] _ in
            self?.isProgressSliderScrubbing = false
        }
    }
    
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
                self.progressSlider.value = Float(time)
        }
        .store(in: &subscriptions)
        
        player?.ratePublisher()
            .sink {[weak self] (rate) in
                print("rate changed:")
                self?.playbackButton.accessibilityLabel = rate == 0.0 ? "Play" : "Pause"
                switch rate {
                case 0.0:
                    print(">> paused")
                    self?.playbackButton.setImage(UIImage(named: "Play"), for: .normal)
                case 1.0:
                    print(">> playing")
                    self?.playbackButton.setImage(UIImage(named: "Pause"), for: .normal)
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
                self.loadingIndicator.isHidden = true
        }
        .store(in: &subscriptions)
        
        player?.isPlaybackBufferEmptyPublisher()
            .sink {[weak self] isPlaybackBufferEmpty in
                print(">> isPlaybackBufferEmpty \(isPlaybackBufferEmpty) ")
                self?.loadingIndicator.isHidden = false
        }
        .store(in: &subscriptions)
        
        player?.statusPublisher()
            .sink { [weak self] status in
                print("received status:")
                self?.playbackButton.isEnabled = status == .readyToPlay
                self?.progressSlider.isEnabled = status == .readyToPlay
                self?.playbackButton.alpha = status == .readyToPlay ? 1.0 : 0.25
                self?.logoImageView.alpha = status == .readyToPlay ? 0.5 : 1.0
                switch status {
                case .unknown:
                    print(">> unknown")
                case .readyToPlay:
                    print(">> ready to play")
                    guard let item = self?.player?.currentItem else { return }
                    self?.progressSlider.maximumValue = Float(item.duration.seconds)
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
