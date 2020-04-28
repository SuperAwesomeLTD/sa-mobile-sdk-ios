//
//  DeviceMock.swift
//  Tests
//
//  Created by Gunhan Sancar on 07/04/2020.
//

@testable import SuperAwesome

class DeviceMock: DeviceType {
    var genericType: String = ""
    var type: String = ""
    var systemVersion: String = ""
    var systemVersionEscaped: String = ""
    var userAgent: String
    
    init() {
        self.userAgent = "mockDeviceUserAgent"
    }
}
