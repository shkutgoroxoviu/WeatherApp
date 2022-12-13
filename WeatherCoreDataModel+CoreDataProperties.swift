//
//  WeatherCoreDataModel+CoreDataProperties.swift
//  Weather
//
//  Created by Гурген Хоршикян on 08.11.2022.
//
//

import Foundation
import CoreData


extension WeatherCoreDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherCoreDataModel> {
        return NSFetchRequest<WeatherCoreDataModel>(entityName: "WeatherCoreDataModel")
    }

    @NSManaged public var location: String
    @NSManaged public var feelLike: Double
    @NSManaged public var lastUpdate: String
    @NSManaged public var tempC: Double
    @NSManaged public var windSpeed: Double
    @NSManaged public var condition: String

}

extension WeatherCoreDataModel : Identifiable {

}
