//
//  VideoPlayerView.swift
//  AVFoundation-Combine
//
//  Created by Juan Carlos Ospina Gonzalez on 02/08/2020.
//  Copyright © 2020 József Vesza. All rights reserved.
//

import Foundation
import UIKit

final class VideoPlayerView: UIView {
    
    /// Logo image on the top left corner.
    private(set) var logoImageView: UIImageView!
    
    /// Button that toggles playback.
    private(set) var playbackButton: UIButton!
    
    /// Image that indicates the video is loading or buffering
    private(set) var loadingIndicator: UIImageView!
    
    /// This slider acts as the playback progress indication
    private(set) var progressSlider: UISlider!
    
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
        
        // Logo image on the top left corner
        logoImageView = UIImageView(image: UIImage(named: "AVLogo"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoImageView)
        logoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.0).isActive = true
        logoImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20.0).isActive = true
        
        // Playback Button
        playbackButton = UIButton(type: .custom)
        playbackButton.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        playbackButton.layer.cornerRadius = 20.0
        playbackButton.layer.masksToBounds = true
        playbackButton.tintColor = .white
        playbackButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playbackButton)
        playbackButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20.0).isActive = true
        playbackButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20.0).isActive = true
        playbackButton.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        playbackButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        // Loading indicator
        loadingIndicator = UIImageView(image: UIImage(named: "Loading"))
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingIndicator)
        loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
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
        progressSlider.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressSlider)
        let trailingConstraint = progressSlider.leadingAnchor.constraint(equalTo: playbackButton.trailingAnchor, constant: 20.0)
        // Prevents `UIViewAlertForUnsatisfiableConstraints` warning because `UIViewSafeAreaLayoutGuide` is {0,0,0,0} while `UIView` is being laid out
        trailingConstraint.priority = .defaultLow
        trailingConstraint.isActive = true
        progressSlider.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20.0).isActive = true
        progressSlider.centerYAnchor.constraint(equalTo: playbackButton.centerYAnchor, constant: 0.0).isActive = true
    }
}
