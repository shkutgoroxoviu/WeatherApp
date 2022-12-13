//
//  UserDefault.swift
//  Weather
//
//  Created by Гурген Хоршикян on 08.11.2022.
//

import Foundation

@propertyWrapper
struct Persist<T> {
    let key: String
    let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue

        if UserDefaults.standard.object(forKey: key) == nil {
            wrappedValue = defaultValue
        }
    }

    var wrappedValue: T {
        get {
            if let val = UserDefaults.standard.object(forKey: key) as? T {
                return val
            } else {
                UserDefaults.standard.set(defaultValue, forKey: key)
                return defaultValue
            }
        }

        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

extension UserDefaults {
    /// Здесь храним дефолтные названия городов
    @Persist(key: "defaultCities", defaultValue: ["Moscow", "Kolomna", "Tbilisi", "Erevan", "Kaliningrad", "Batumi"])
    static var cities: [String]
}
