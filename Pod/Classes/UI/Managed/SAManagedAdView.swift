//
//  SAManagedAdView.swift
//
//  Created by Mark on 08/04/2021.
//

import UIKit
import WebKit

protocol SAManagedAdViewDelegate: AdJSMessageHandlerDelegate {
    func onAdClick(url: URL)
}

@objc(SAManagedAdView)
public final class SAManagedAdView: UIView, Injectable {

    internal var finishedLoading = false

    private var callback: AdEventCallback?
    private var placementId: Int = 0
    private var adJSBridge: AdJSMessageHandler?
    private var loggerJSMessageHandler: LoggingJSMessageHandler?
    private weak var delegate: SAManagedAdViewDelegate? {
        didSet {
            adJSBridge?.delegate = delegate
        }
    }

    private lazy var sknetworkManager: SKAdNetworkManager = dependencies.resolve()
    private var logger: LoggerType = dependencies.resolve(param: SAManagedAdView.self)

    lazy var webView: WKWebView = {
        let userContentController = WKUserContentController()
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true

        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.userContentController = userContentController
        adJSBridge = AdJSMessageHandler(withWebViewConfiguration: configuration)
        loggerJSMessageHandler = LoggingJSMessageHandler(withWebViewConfiguration: configuration, logger: logger)

        if #available(iOS 14.0, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        }
        return WKWebView(frame: bounds, configuration: configuration)
    }()

    init() {
        super.init(frame: CGRect.zero)
        initView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    private func initView() {
        addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 0),
            webView.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: 0),
            webView.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: 0),
            webView.topAnchor.constraint(equalTo: safeTopAnchor, constant: 0)
        ])
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }

    public func load(placementId: Int, html: String, baseUrl: String?) {
        if let baseUrl = baseUrl, let url = URL(string: baseUrl) {
            self.placementId = placementId

            logger.info(html)

            webView.loadHTMLString(html, baseURL: url)

            if #available(iOS 14.5, *) {
                sknetworkManager.startImpression(lineItemId: placementId, creativeId: 1)
            }
        }
    }

    func setDelegate(_ delegate: SAManagedAdViewDelegate? = nil) {
        self.delegate = delegate
    }

    public func setCallback(value: AdEventCallback? = nil) {
        callback = value
    }

    public func setColor(value: Bool) {
        backgroundColor = value ? .clear : Constants.backgroundGray
    }

    func close() {
        if #available(iOS 14.5, *) {
            sknetworkManager.endImpression()
            webView.closeAllMediaPresentations()
        }

        // Stop any playing media
        webView.loadHTMLString("", baseURL: nil)
        webView.configuration.userContentController.removeAllUserScripts()
        webView.configuration.userContentController.removeScriptMessageHandler(forName: AdJSMessageHandler.bridgeKey)
        webView.configuration.userContentController.removeScriptMessageHandler(forName: LoggingJSMessageHandler.bridgeKey)
    }

    func playVideo() {
        webView.evaluateJavaScript("window.dispatchEvent(new Event('SA_AD_JS_BRIDGE.appRequestedPlay'));")
    }

    func pauseVideo() {
        webView.evaluateJavaScript("window.dispatchEvent(new Event('SA_AD_JS_BRIDGE.appRequestedPause'));")
    }

    deinit {
        adJSBridge = nil
        loggerJSMessageHandler = nil
    }
}

// MARK: WKNavigationDelegate, WKUIDelegate

extension SAManagedAdView: WKNavigationDelegate, WKUIDelegate {
    public func webView(_ webView: WKWebView,
                        createWebViewWith configuration: WKWebViewConfiguration,
                        for navigationAction: WKNavigationAction,
                        windowFeatures: WKWindowFeatures) -> WKWebView? {
        if finishedLoading && navigationAction.navigationType == .other {
            if let url = navigationAction.request.url {
                delegate?.onAdClick(url: url)
            }
        }
        return nil
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        finishedLoading = true
    }

    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}
