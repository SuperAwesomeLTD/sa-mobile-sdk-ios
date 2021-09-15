//
//  InterstitialAd.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 04/09/2020.
//

import UIKit

public class InterstitialAd: NSObject, Injectable {
    private static var controller: AdControllerType = dependencies.resolve()
    private static var logger: LoggerType = dependencies.resolve(param: InterstitialAd.self)

    private(set) static var isParentalGateEnabled: Bool = Constants.defaultParentalGate
    private(set) static var isBumperPageEnabled: Bool = Constants.defaultBumperPage
    private(set) static var isTestingEnabled: Bool = Constants.defaultTestMode
    private(set) static var orientation: Orientation = Constants.defaultOrientation
    private(set) static var isMoatLimitingEnabled: Bool = Constants.defaultMoatLimitingState
    private static let factory = RequestFactoryImpl()

    // MARK: - Public functions

    /**
     * Method that loads an ad into the queue.
     * Ads can only be loaded once and then can be reloaded after they've
     * been played.
     *
     * - Parameter placementId: The Ad placement id to load data for
     */
    @objc
    public class func load(_ placementId: Int) {
        logger.info("load() for: \(placementId)")
        controller.load(placementId, makeAdRequest())
    }

    /**
     * Method that, if an ad data is loaded, will play
     * the content for the user
     *
     * - Parameters:
     *   - placementId: The Ad placement id to play an ad for
     *   - parent:  The parent view controller
     */
    @objc
    public class func play(_ placementId: Int, fromVC parent: UIViewController?) {
        logger.info("play()")
        // guard against invalid ad formats
        guard let adResponse = controller.adResponse,
              adResponse.advert.creative.format != CreativeFormatType.video else {
            controller.adFailedToShow()
            return
        }

        let viewController = InterstitialAdViewController(adResponse: adResponse,
                                                          parentGateEnabled: isParentalGateEnabled,
                                                          bumperPageEnabled: isBumperPageEnabled,
                                                          testingEnabled: isTestingEnabled,
                                                          orientation: orientation,
                                                          delegate: self.controller.callback)
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .coverVertical
        parent?.present(viewController, animated: true, completion: nil)
    }

    /**
     * Method that returns whether ad data for a certain placement
     * has already been loaded
     * - Parameter placementId: the Ad placement id to check for
     * - Returns:  true or false
     */
    @objc
    public class func hasAdAvailable(_ placementId: Int) -> Bool { controller.adAvailable }

    @objc
    public class func setCallback(_ callback: @escaping AdEventCallback) { controller.callback = callback }

    @available(*, deprecated, message: "Use `AwesomeAdsSdk.Configuration` instead")
    @objc
    public class func setConfiguration(_ value: Int) { }

    @available(*, deprecated, message: "Use `AwesomeAdsSdk.Configuration` instead")
    @objc
    public class func setConfigurationProduction() { }

    @available(*, deprecated, message: "Use `AwesomeAdsSdk.Configuration` instead")
    @objc
    public class func setConfigurationStaging() { }

    @objc
    public class func setOrientation(_ orientation: Orientation) { self.orientation = orientation }

    @objc
    public class func setOrientationAny() { setOrientation(.any) }

    @objc
    public class func setOrientationPortrait() { setOrientation(.portrait) }

    @objc
    public class func setOrientationLandscape() { setOrientation(.landscape) }

    @objc
    public class func setTestMode(_ value: Bool) { isTestingEnabled = value }

    @objc
    public class func enableTestMode() { setTestMode(true) }

    @objc
    public class func disableTestMode() { setTestMode(false) }

    @objc
    public class func disableMoatLimiting() { isMoatLimitingEnabled = false }

    @objc
    public class func setBumperPage(_ value: Bool) { isBumperPageEnabled = value }

    @objc
    public class func enableBumperPage() { setBumperPage(true) }

    @objc
    public class func disableBumperPage() { setBumperPage(false) }

    @objc
    public class func setParentalGate(_ value: Bool) { isParentalGateEnabled = value }

    @objc
    public class func enableParentalGate() { setParentalGate(true) }

    @objc
    public class func disableParentalGate() { setParentalGate(false) }

    // MARK: - Private functions

    private static func makeAdRequest() -> AdRequest {
        factory.makeRequest(isTestEnabled: isTestingEnabled,
                                   screen: .interstitial,
                                   size: UIScreen.main.bounds.size)
    }
}
