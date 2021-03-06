//
//  VideoPlayerContentOverlay.swift
//  AVFoundation-Combine
//
//  Created by Juan Carlos Ospina Gonzalez on 02/08/2020.
//  Copyright © 2020 József Vesza. All rights reserved.
//

// System
import Foundation
import UIKit

final class VideoPlayerContentOverlay: UIView {
    
    /// Logo image on the top left corner.
    private(set) var logoImageView: UIImageView!
    
    /// Button that toggles playback.
    private(set) var playbackButton: UIButton!
    
    /// Image that indicates the video is loading or buffering
    private(set) var loadingIndicator: UIImageView!

    #if os(iOS)
    /// This slider acts as the playback progress indication
    private(set) var progressSlider: UISlider!
    #endif

    /// Size of the play/pause button
    private var playButtonSize: CGSize {
        #if os(iOS)
        return CGSize(width: 40.0, height: 40.0)
        #else
        return CGSize(width: 120.0, height: 120.0)
        #endif
    }
    
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
        playbackButton.layer.cornerRadius = playButtonSize.width * 0.5
        playbackButton.layer.masksToBounds = true
        playbackButton.tintColor = .white

        loadingIndicator = UIImageView(image: UIImage(named: "Loading"))
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = (Double.pi * 2)
        animation.duration = 0.5
        animation.repeatCount = Float.infinity
        loadingIndicator.layer.add(animation, forKey: "rotation")
        #if os(iOS)
        progressSlider = UISlider()
        progressSlider.tintColor = UIColor(named: "Red")
        progressSlider.setThumbImage(UIImage(named: "SliderThumb"), for: .normal)
        #endif
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
            playbackButton.widthAnchor.constraint(equalToConstant: playButtonSize.width),
            playbackButton.heightAnchor.constraint(equalToConstant: playButtonSize.height)
        ])
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        #if os(iOS)
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
        #endif
    }
}
