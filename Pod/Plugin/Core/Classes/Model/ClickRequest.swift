//
//  ClickRequest.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 15/04/2020.
//

struct ClickRequest: Codable {
    let placement: Int
    let bundle: String
    let creative: Int
    let line_item: Int
    let ct: Int
    let sdkVersion: String
    let rnd: Int
}