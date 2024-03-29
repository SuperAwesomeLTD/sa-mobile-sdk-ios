//
//  VideoAdUITests.swift
//  SuperAwesomeExampleUITests
//
//  Created by Tom O'Rourke on 07/06/2022.
//

import XCTest
import DominantColor

class VideoAdUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testCloseButtonAppearsWithNoDelay_WhenConfigured() throws {

//        let app = localApp()
//        app.launch()
//
//        // Given
//
//        // Close button appearing with no delay is configured via the SegmentControl
//        app.segmentedControls["configControl"].buttons.element(boundBy: 1).tap()
//
//        // Tap the video ad in the list
//        app.tables.matching(identifier: "adsTableView").cells.element(matching: .cell,
//                                                                      identifier: "Video Test Multi Id").tap()
//
//        let padlockExpectation = expectation(
//            for: NSPredicate(format: "exists == true"),
//            evaluatedWith: app.buttons["padlock"],
//            handler: .none
//        )
//
//        // When
//
//        // The padlock is visible (it's visible immediately)
//        let padlockResult = XCTWaiter.wait(for: [padlockExpectation], timeout: Timeouts.standard.duration)
//        XCTAssertEqual(padlockResult, .completed)
//
//        // Then
//
//        // The close button is visible
//        XCTAssertTrue(app.buttons["closeButton"].exists)
    }

    // NOTE: This test is flakey on the CI and times out.
    func testCloseButtonAppearsWithDelay_WhenConfigured() throws {

//        let app = localApp()
//        app.launch()
//
//        // Given
//
//        // Close button appearing with a delay is configured via the SegmentControl
//        app.segmentedControls["configControl"].buttons.element(boundBy: 0).tap()
//
//        // Tap the video ad in the list
//        app.tables.matching(identifier: "adsTableView").cells.element(matching: .cell,
//                                                                      identifier: "Video Test Multi Id").tap()
//
//        let padlockExpectation = expectation(
//            for: NSPredicate(format: "exists == true"),
//            evaluatedWith: app.buttons["padlock"],
//            handler: .none
//        )
//
//        let closeButtonExpectation = expectation(
//            for: NSPredicate(format: "exists == true"),
//            evaluatedWith: app.buttons["closeButton"],
//            handler: .none
//        )
//
//        // When
//
//        // The padlock is visible (it's visible immediately)
//        let padlockResult = XCTWaiter.wait(for: [padlockExpectation], timeout: Timeouts.extraLong.duration)
//        XCTAssertEqual(padlockResult, .completed)
//
//        // The close button is not initially visible
//        XCTAssertFalse(app.buttons["closeButton"].exists)
//
//        // Then
//
//        // The close button is visible after a delay
//        let closeButtonResult = XCTWaiter.wait(for: [closeButtonExpectation], timeout: Timeouts.extraLong.duration)
//
//        XCTAssertEqual(closeButtonResult, .completed)
    }

    func testNonKSF_VPAID_ad_loads_successfully() throws {

//        let app = localApp()
//        app.launch()
//
//        // Given
//
//        app.segmentedControls["configControl"].buttons.element(boundBy: 0).tap()
//
//        // Tap the non-ksf vpaid video ad in the list
//        app.tables.matching(identifier: "adsTableView").cells.element(matching: .cell,
//                                                                      identifier: "VPAID Video Flat Colour").tap()
//
//        // When
//
//        let webView = app.webViews.firstMatch
//        let playButton = webView.images.firstMatch
//
//        // The play button is visible
//        let playButtonExpectation = expectation(
//            for: NSPredicate(format: "exists == true"),
//            evaluatedWith: playButton,
//            handler: .none
//        )
//
//        let playButtonResult = XCTWaiter.wait(for: [playButtonExpectation], timeout: Timeouts.standard.duration)
//        XCTAssertEqual(playButtonResult, .completed)
//
//        // Tap the play button
//        let playButtonCoordinate = webView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
//        playButtonCoordinate.tap()
//
//        // Then
//
//        // Wait for the webview to load, crop a sample from the centre and test the colour
//        sleep(5)
//
//        let screenshot = XCUIScreen.main.screenshot().image
//        let crop = screenshot.centreCroppedTo(CGSize(width: 50, height: 50))
//
//        let expectedColour = "#F5E871"
//        let sampledColour = crop.dominantColors().contains(where: { $0.hexString() == expectedColour })
//
//        XCTAssertNotNil(sampledColour)
    }
}
