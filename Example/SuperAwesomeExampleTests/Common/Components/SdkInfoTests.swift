//
//  SdkInfoTests.swift
//  Tests
//
//  Created by Gunhan Sancar on 21/04/2020.
//

import XCTest
import Nimble
@testable import SuperAwesome

class SdkInfoTests: XCTestCase {
    func testSdkInfo() throws {
        // Given
        let mainBundle = BundleMock.make(name: "main Name", bundleId: "mainId", versionNumber: "mainVersion", localizations: ["xx"])
        let locale = Locale(identifier: "en-US")

        // When
        let sdk = SdkInfo(mainBundle: mainBundle, locale: locale, encoder: CustomEncoder())
        SdkInfo.overrideVersion(nil, withPlatform: nil)

        // Then
        expect(sdk.bundle).to(equal("mainId"))
        expect(sdk.lang).to(equal("xx_US"))
        expect(sdk.name).to(equal("main%20Name"))
        expect(sdk.version).to(equal("ios_\(SDK_VERSION)"))
        expect(sdk.versionNumber).to(equal("\(SDK_VERSION)"))
    }

    func test_overrideVersion() throws {
        // Given
        let mainBundle = BundleMock.make(name: "main Name", bundleId: "mainId", versionNumber: "mainVersion", localizations: ["xx"])
        let locale = Locale(identifier: "en-US")
        let sdk = SdkInfo(mainBundle: mainBundle, locale: locale, encoder: CustomEncoder())

        // When
        SdkInfo.overrideVersion("9.8.7", withPlatform: "unity")

        // Then
        expect(sdk.version).to(equal("unity_9.8.7"))
    }
}
