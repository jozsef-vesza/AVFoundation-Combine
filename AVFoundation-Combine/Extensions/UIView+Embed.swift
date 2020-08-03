//
//  UIView+Embed.swift
//  AVFoundation-Combine
//
//  Created by Juan Carlos Ospina Gonzalez on 03/08/2020.
//  Copyright © 2020 József Vesza. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addSubviewAndFillBounds(_ subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        [
            subview.leadingAnchor.constraint(equalTo: leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor),
            subview.topAnchor.constraint(equalTo: topAnchor),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor),
        ].forEach { $0.isActive = true}
    }
}
