//
//  Weather.swift
//  Weather
//
//  Created by Гурген Хоршикян on 25.10.2022.
//

import Foundation

struct Weather: Codable {
    let location: Location
    let current: Current
}

struct Location: Codable {
    let name: String
    let localtime: String
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        guard
            let data = formatter.date(from: localtime)
        else { return " "}
        
        let dataString = formatter.string(from: data)
        
        return dataString
    }
}

struct Current: Codable {
    let tempC: Double
    let windMph: Double
    let feelslikeC: Double
    let condition: Condition
    
    enum CodingKeys : String, CodingKey {
        case tempC = "temp_c"
        case windMph = "wind_mph"
        case feelslikeC = "feelslike_c"
        case condition
    }
}

struct Condition: Codable {
    let text: String
    let icon: String
    
    var iconUrl: String {
        "https://weatherapi-com.p.rapidapi.com" + icon
    }
}
