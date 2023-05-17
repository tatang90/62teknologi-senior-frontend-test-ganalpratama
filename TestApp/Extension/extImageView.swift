//
//  extImageView.swift
//  TestApp
//
//  Created by Icon+ Gaenael on 17/05/23.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activity)
        activity.startAnimating()
        NSLayoutConstraint.activate([
            activity.centerYAnchor.constraint(equalTo: centerYAnchor),
            activity.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        activity.removeFromSuperview()
                    }
                }
            }
        }
    }
}
