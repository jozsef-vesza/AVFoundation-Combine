//
//  VideoPlayerContentOverlay.swift
//  AVFoundation-Combine
//
//  Created by Juan Carlos Ospina Gonzalez on 02/08/2020.
//  Copyright © 2020 József Vesza. All rights reserved.
//

import Foundation
import UIKit

final class VideoPlayerContentOverlay: UIView {
    
    /// Logo image on the top left corner.
    private(set) var logoImageView: UIImageView!
    
    /// Button that toggles playback.
    private(set) var playbackButton: UIButton!
    
    /// Image that indicates the video is loading or buffering
    private(set) var loadingIndicator: UIImageView!
    
    /// This slider acts as the playback progress indication
    private(set) var progressSlider: UISlider!
    
    /// Semi transparent background that covers the UI when the replay button is shown
    private(set) var replayOverlay = UIView()
    
    /// Button used to restart the stream once it has completed
    private(set) var replayButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        logoImageView = UIImageView(image: UIImage(named: "AVLogo"))
        
        playbackButton = UIButton(type: .custom)
        playbackButton.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        playbackButton.layer.cornerRadius = 20.0
        playbackButton.layer.masksToBounds = true
        playbackButton.tintColor = .white

        loadingIndicator = UIImageView(image: UIImage(named: "Loading"))
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = (Double.pi * 2)
        animation.duration = 0.5
        animation.repeatCount = Float.infinity
        loadingIndicator.layer.add(animation, forKey: "rotation")
        
        progressSlider = UISlider()
        progressSlider.tintColor = UIColor(named: "Red")
        progressSlider.setThumbImage(UIImage(named: "SliderThumb"), for: .normal)
        
        replayOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        replayButton = UIButton(type: .custom)
        replayButton.tintColor = .white
        replayButton.setImage(UIImage(named: "Replay"), for: .normal)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.0),
            logoImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20.0)
        ])
        
        playbackButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playbackButton)
        NSLayoutConstraint.activate([
            playbackButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20.0),
            playbackButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            playbackButton.widthAnchor.constraint(equalToConstant: 40.0),
            playbackButton.heightAnchor.constraint(equalToConstant: 40.0)
        ])
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        progressSlider.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressSlider)
        let trailingConstraint = progressSlider.leadingAnchor.constraint(equalTo: playbackButton.trailingAnchor, constant: 20.0)
        // Prevents `UIViewAlertForUnsatisfiableConstraints` warning because `UIViewSafeAreaLayoutGuide` is {0,0,0,0} while `UIView` is being laid out
        trailingConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            trailingConstraint,
            progressSlider.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
            progressSlider.centerYAnchor.constraint(equalTo: playbackButton.centerYAnchor, constant: 0.0)
        ])
        
        replayOverlay.translatesAutoresizingMaskIntoConstraints = false
        addSubview(replayOverlay)
        NSLayoutConstraint.activate([
            replayOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            replayOverlay.topAnchor.constraint(equalTo: topAnchor),
            replayOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            replayOverlay.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        replayButton.translatesAutoresizingMaskIntoConstraints = false
        replayOverlay.addSubview(replayButton)
        
        NSLayoutConstraint.activate([
            replayButton.centerXAnchor.constraint(equalTo: replayOverlay.centerXAnchor),
            replayButton.centerYAnchor.constraint(equalTo: replayOverlay.centerYAnchor),
            replayButton.widthAnchor.constraint(equalToConstant: 44),
            replayButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
