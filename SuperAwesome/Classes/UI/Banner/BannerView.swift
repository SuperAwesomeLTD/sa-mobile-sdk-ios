//
//  Banner.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 20/08/2020.
//

import UIKit

/// Class that abstracts away the process of loading & displaying Banner type Ad.
@objc(SABannerAd)
public class BannerView: UIView, Injectable {

    private let accessibilityPrefix = "SuperAwesome.Banner."

    private lazy var imageProvider: ImageProviderType = dependencies.resolve()
    private lazy var controller: AdControllerType = dependencies.resolve()
    private lazy var logger: LoggerType = dependencies.resolve(param: BannerView.self)
    private lazy var sknetworkManager: SKAdNetworkManager = dependencies.resolve()

    private var webView: WebView?
    private var padlock: UIButton?
    private var viewableDetector: ViewableDetectorType?
    private var hasBeenVisible: VoidBlock?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    // MARK: - Internal functions

    func configure(adResponse: AdResponse, delegate: AdEventCallback?, hasBeenVisible: VoidBlock?) {
        self.hasBeenVisible = hasBeenVisible
        setAdResponse(adResponse)
        setCallback(delegate)
    }

    // MARK: - Public functions

    /**
     * Method that loads an ad into the queue.
     * Ads can only be loaded once and then can be reloaded after they've
     * been played.
     *
     * - Parameters:
     *  - placementId: the Ad placement id to load data for
     */
    @objc
    public func load(_ placementId: Int) {
        load(placementId, options: nil)
    }

    /**
     * Method that loads an ad into the queue.
     * Ads can only be loaded once and then can be reloaded after they've
     * been played.
     *
     * - Parameters:
     *  - placementId: the Ad placement id to load data for
     *  - options: an optional dictionary of data to send with an ad's requests and events. Supports String or Int values.
     */
    @objc
    public func load(_ placementId: Int, options: [String: Any]? = nil) {
        logger.info("load() for: \(placementId)")
        controller.load(placementId, makeAdRequest(with: options))
    }

    /**
     * Method that loads an ad into the queue.
     * Ads can only be loaded once and then can be reloaded after they've
     * been played.
     *
     * - Parameters:
     *   - placementId: the Ad placement id to load data for
     *   - lineItemId: id of the line item
     *   - creativeId: id of the creative
     */
    @objc
    public func load(_ placementId: Int, lineItemId: Int, creativeId: Int) {
        load(placementId, lineItemId: lineItemId, creativeId: creativeId, options: nil)
    }

    /**
     * Method that loads an ad into the queue.
     * Ads can only be loaded once and then can be reloaded after they've
     * been played.
     *
     * - Parameters:
     *   - placementId: the Ad placement id to load data for
     *   - lineItemId: id of the line item
     *   - creativeId: id of the creative
     *   - options: an optional dictionary of data to send with an ad's requests and events. Supports String or Int values.
     */
    @objc
    public func load(_ placementId: Int, lineItemId: Int, creativeId: Int, options: [String: Any]? = nil) {
        logger.info("load() for placement Id: \(placementId) lineItemId: \(lineItemId), creativeId: \(creativeId)")
        controller.load(placementId, lineItemId: lineItemId, creativeId: creativeId, makeAdRequest(with: options))
    }

    public func getAd() -> Ad? {
       controller.adResponse?.advert
    }

    /// Method that, if an ad data is loaded, will play the content for the user
    @objc
    public func play() {
        logger.info("play()")
        // guard against invalid ad formats
        guard let adResponse = controller.adResponse, let html = adResponse.html,
              adResponse.advert.creative.format != CreativeFormatType.video, !controller.closed else {
            controller.adFailedToShow()
            return
        }

        addWebView()

        controller.triggerImpressionEvent()

        showPadlockIfNeeded()
        if #available(iOS 14.5, *) {
            sknetworkManager.startImpression(lineItemId: adResponse.advert.lineItemId,
                                             creativeId: adResponse.advert.creative.id)
        }

        webView?.loadHTML(html, withBase: adResponse.baseUrl,
                          sourceSize: CGSize(width: adResponse.advert.creative.details.width,
                                             height: adResponse.advert.creative.details.height))
    }

    private func showPadlockIfNeeded() {
        guard controller.showPadlock, let webView = webView  else { return }

        let padlock = UIButton(frame: CGRect.zero)
        padlock.translatesAutoresizingMaskIntoConstraints = false
        padlock.setImage(imageProvider.safeAdImage, for: .normal)
        padlock.addTarget(self, action: #selector(padlockAction), for: .touchUpInside)
        padlock.accessibilityIdentifier = "\(accessibilityPrefix)Buttons.Padlock"
        webView.addSubview(padlock)

        NSLayoutConstraint.activate([
            padlock.widthAnchor.constraint(equalToConstant: 77.0),
            padlock.heightAnchor.constraint(equalToConstant: 31.0),
            padlock.leadingAnchor.constraint(equalTo: webView.safeLeadingAnchor, constant: 12.0),
            padlock.topAnchor.constraint(equalTo: webView.safeTopAnchor, constant: 12.0)
        ])

        self.padlock = padlock
    }

    /// Method that is called to close the ad
    @objc
    public func close() {
        viewableDetector = nil
        controller.close()
        removeWebView()
        if #available(iOS 14.5, *) {
            sknetworkManager.endImpression()
        }
    }

    /**
     * Method that returns whether ad data for a certain placement
     * has already been loaded
     *
     * @return              true or false
     */
    @objc
    public func hasAdAvailable() -> Bool { controller.adResponse != nil }

    /// Method that gets whether the banner is closed or not
    @objc
    public func isClosed() -> Bool { controller.closed }

    /// Callback function
    @objc
    public func setCallback(_ callback: AdEventCallback?) { controller.callback = callback }

    @objc
    public func setTestMode(_ value: Bool) { controller.testEnabled = value }

    @objc
    public func enableTestMode() { setTestMode(true) }

    @objc
    public func disableTestMode() { setTestMode(false) }

    @available(*, deprecated, message: "Use `AwesomeAds.initSDK()` to select configuration")
    @objc
    public func setConfigurationProduction() { }

    @available(*, deprecated, message: "Use `AwesomeAds.initSDK()` to select configuration")
    @objc
    public func setConfigurationStaging() { }

    @objc
    public func setParentalGate(_ value: Bool) { controller.parentalGateEnabled = value }

    @objc
    public func enableParentalGate() { setParentalGate(true) }

    @objc
    public func disableParentalGate() { setParentalGate(false) }

    @objc
    public func setBumperPage(_ value: Bool) { controller.bumperPageEnabled = value }

    @objc
    public func enableBumperPage() { setBumperPage(true) }

    @objc
    public func disableBumperPage() { setBumperPage(false) }

    @objc
    public func setColorTransparent() { setColor(true) }

    @objc
    public func setColorGray() { setColor(false) }

    @objc
    public func setColor(_ value: Bool) {
        backgroundColor = value ? UIColor.clear : Constants.backgroundGray
    }

    // MARK: - Private functions

    private func initialize() {
        setColor(false)
    }

    private func setAdResponse(_ adResponse: AdResponse) {
        controller.adResponse = adResponse
    }

    private func makeAdRequest(with options: [String: Any]?) -> AdRequest {
        AdRequest(test: controller.testEnabled,
                  position: AdRequest.Position.aboveTheFold,
                  skip: AdRequest.Skip.no,
                  playbackMethod: AdRequest.Playback.soundOn.rawValue,
                  startDelay: AdRequest.StartDelay.preRoll,
                  instl: AdRequest.FullScreen.off,
                  width: Int(frame.size.width),
                  height: Int(frame.size.height),
                  options: options)
    }

    private func addWebView() {
        removeWebView()

        webView = WebView(frame: CGRect.zero, configuration: WebView.defaultConfiguration())

        if let view = webView {
            view.delegate = self
            view.translatesAutoresizingMaskIntoConstraints = false

            addSubview(view)

            let aspectRatio = controller.adResponse?.aspectRatio() ?? 1.0
            logger.info("aspectRatio(): \(aspectRatio)")
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: self.topAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        }
    }

    private func removeWebView() {
        padlock?.removeFromSuperview()
        padlock = nil
        webView?.removeFromSuperview()
        webView = nil
    }

    @objc private func padlockAction() { controller.handleSafeAdTap() }
}

extension BannerView: WebViewDelegate {
    func webViewOnStart() {
        logger.info("webViewOnStart")
        controller.adShown()

        viewableDetector = dependencies.resolve() as ViewableDetectorType
        viewableDetector?.start(for: self, hasBeenVisible: { [weak self] in
            self?.controller.triggerViewableImpression()
            self?.hasBeenVisible?()
        })
    }

    func webViewOnError() {
        logger.info("webViewOnError")
        controller.adFailedToShow()
    }

    func webViewOnClick(url: URL) {
        logger.info("webViewOnClick")
        controller.handleAdTap(url: url)
    }
}
