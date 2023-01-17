//
//  Constants.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 09/09/2020.
//

struct Constants {
    static let defaultClickThresholdInSecs = 5
    static let defaultTestMode = false
    static let defaultParentalGate = false
    static let defaultBumperPage = false
    static let defaultCloseAtEnd = true
    static let defaultCloseWarning = false
    static let defaultMuteOnStart = false
    static let defaultCloseButton: CloseButtonState = .hidden
    static let defaultCloseButtonInterstitial: CloseButtonState = .visibleWithDelay
    static let defaultSmallClick = false
    static let defaultOrientation = Orientation.any
    static let defaultEnvironment = Environment.production
    static let defaultStartDelay = AdRequest.StartDelay.preRoll

    static let backgroundGray = UIColor(red: 224.0 / 255.0, green: 224.0 / 255.0,
                                        blue: 224.0 / 255.0, alpha: 1)

    static let defaultSafeAdUrl = "https://ads.superawesome.tv/v2/safead"
    static let defaultBaseUrl = "https://ads.superawesome.tv"
}
