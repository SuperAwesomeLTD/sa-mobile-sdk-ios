//
//  UIView+Extensions.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 24/08/2020.
//

import UIKit

extension UIView {
    func registerForOrientationDidChangeNotification(_ block: @escaping (Notification) -> Void) {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("UIDeviceOrientationDidChangeNotification"),
            object: nil,
            queue: nil,
            using: block)
    }

    func unregisterForOrientationDidChangeNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name("UIDeviceOrientationDidChangeNotification"),
            object: nil)
    }

    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }

    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomAnchor
        }
    }

    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.trailingAnchor
        } else {
            return trailingAnchor
        }
    }

    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leadingAnchor
        } else {
            return leadingAnchor
        }
    }

    func bind(toTheEdgesOf otherView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let margins = otherView.layoutMarginsGuide

        self.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0.0).isActive = true
        self.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0.0).isActive = true
        self.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0.0).isActive = true
        self.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -8.0).isActive = true
    }

    func bind(toTopRightOf otherView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let margins = otherView.layoutMarginsGuide

        if #available(iOS 11.0, *) {
            self.topAnchor.constraint(equalToSystemSpacingBelow: otherView.safeAreaLayoutGuide.topAnchor, multiplier: 1.0).isActive = true
            self.trailingAnchor.constraint(equalTo: otherView.layoutMarginsGuide.trailingAnchor, constant: 0.0).isActive = true
        } else {
            self.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0.0).isActive = true
            self.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0.0).isActive = true
        }
        self.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        self.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    }

    /// Checks to see if the `View` is visible to the user
    var isVisibleToUser: Bool {
        if isHidden || superview == nil { return false }

        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return false
        }

        let viewFrame = convert(bounds, to: rootViewController.view)

        return viewFrame.minX >= 0 &&
            viewFrame.maxX <= rootViewController.view.bounds.width &&
            viewFrame.minY >= 0 &&
            viewFrame.maxY <= rootViewController.view.bounds.height
    }
}
