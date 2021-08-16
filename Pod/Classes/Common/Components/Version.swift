//
//  Version.swift
//  SuperAwesome
//
//  Created by Mark on 07/05/2021.
//

import Foundation

class Version {
    static var version = "8.1.1"
    static var sdk = "ios"

    static var pluginName: String {
        #if MOPUB_PLUGIN
            return "_mopub"
        #elseif ADMOB_PLUGIN
            return "_admob"
        #endif
            return ""
        }

        static func getSdkVersion() -> String {
            return "\(sdk)_\(version)\(pluginName)"
        }

    }
