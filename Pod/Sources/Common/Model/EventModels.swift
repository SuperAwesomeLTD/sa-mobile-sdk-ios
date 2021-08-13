//
//  EventModels.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 30/04/2020.
//

struct EventQuery: Codable {
    let placement: Int
    let bundle: String
    let creative: Int
    let lineItem: Int
    let connectionType: ConnectionType
    let sdkVersion: String
    let rnd: Int
    let type: EventType?
    let noImage: Bool?
    let data: String?
    
    enum CodingKeys: String, CodingKey {
        case placement
        case bundle
        case creative
        case lineItem = "line_item"
        case connectionType = "ct"
        case sdkVersion
        case rnd
        case type
        case noImage = "no_image"
        case data
    }
    
    var params: [String: String] {
        ["placement": "\(placement)",
         "bundle": bundle,
         "creative": "\(creative)",
         "line_item": "\(lineItem)",
         "ct": "\(connectionType)",
         "sdkVersion": sdkVersion,
         "rnd": "\(rnd)",
         "type": "\(type?.serverName ?? "")",
         "no_image": "\(noImage ?? false)"
        ]
    }
}

struct PopJamEventData{
    let placement: Int
    let lineItem: Int
    let creative: Int
    let type: String
    
    var dataStr: String {
        """
            {"placement": \(placement), "line_item":\(lineItem), "creative":\(creative),"type":\(type)}
        """
    }
    
    enum CodingKeys: String, CodingKey {
        case lineItem = "line_item"
        case placement
        case creative
        case type
    }
}

struct PopJamEvent {
    let sdkVersion: String
    let data: PopJamEventData
    let rnd: Int
    
    var queryParams:  [String:String] {
        [ "sdkVersion": "\(sdkVersion)", "rnd":"\(rnd)","data":data.dataStr ]
    }
}

struct EventData: Codable {
    let placement: Int
    let lineItem: Int
    let creative: Int
    let type: EventType
    
    enum CodingKeys: String, CodingKey {
        case lineItem = "line_item"
        case placement
        case creative
        case type
    }
}

enum EventType: String, Codable {
    case impressionDownloaded
    case viewableImpression
    case parentalGateOpen
    case parentalGateClose
    case parentalGateFail
    case parentalGateSuccess
    case dwellTime
    
    enum CodingKeys: String, CodingKey {
        case viewableImpression = "viewable_impression"
        case dwellTime = "viewTime"
        case impressionDownloaded
        case parentalGateOpen
        case parentalGateClose
        case parentalGateFail
        case parentalGateSuccess
    }
    
    var serverName: String {
        switch self {
        case .viewableImpression: return "viewable_impression"
        case .dwellTime: return "viewTime"
        default:
            return self.rawValue
        }
    }
}
