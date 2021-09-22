//
//  Models.swift
//  DemoMeteor
//
//  Created by Jagdish on 22/09/21.
//

import Foundation

// MARK: - MeteorElement
struct MeteorElement: Codable {
    let name, id, nametype, recclass: String
    let mass: String?
    let year: String?
    let fall, reclat: String?
    let reclong: String?
    let geolocation: Geolocation?
    let isFavorite: Bool?
}

// MARK: - Geolocation
struct Geolocation: Codable {
    let latitude, longitude: String
}

