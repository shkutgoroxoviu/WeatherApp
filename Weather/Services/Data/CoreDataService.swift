//
//  CoreDataService.swift
//  Weather
//
//  Created by Гурген Хоршикян on 08.11.2022.
//

import UIKit
import CoreData

class CoreDataService {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    
    func fetchOneElement(name: String) -> WeatherCoreDataModel? {
        // Создаем запрос в базу данных, который возвращает все элементы
        let request: NSFetchRequest<WeatherCoreDataModel> = WeatherCoreDataModel.fetchRequest()
        // Добавляем параметр для запроса, чтобы получить определенный элемент
        request.predicate = NSPredicate(format: "location == %@", name)
        
        do {
            let model = try context.fetch(request)
            
            guard !model.isEmpty else {
                return nil
            }
            return model[0]
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func update(with weather: Weather) {
        let request: NSFetchRequest<WeatherCoreDataModel> = WeatherCoreDataModel.fetchRequest()
        request.predicate = NSPredicate(format: "location == %@", weather.location.name)
        
        do {
            let models = try context.fetch(request)
            
            guard !models.isEmpty else {
                addCity(weather: weather)
                return
            }
            
            models[0].location = weather.location.name
            models[0].feelLike = weather.current.feelslikeC
            models[0].lastUpdate = weather.location.localtime
            models[0].tempC = weather.current.tempC
            models[0].windSpeed = weather.current.windMph
            models[0].condition = weather.current.condition.text
            
            try context.save()
            print("\(weather.location.name) update ✅✅✅")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchWeather() -> [WeatherCoreDataModel]? {
        let request: NSFetchRequest<WeatherCoreDataModel> = WeatherCoreDataModel.fetchRequest()
        
        do {
            let models = try context.fetch(request)
            return models
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func addCity(weather: Weather) {
        let entity = NSEntityDescription.entity(forEntityName: "WeatherCoreDataModel", in: context)
        let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! WeatherCoreDataModel
        
        taskObject.condition = weather.current.condition.text
        taskObject.location = weather.location.name
        taskObject.feelLike = weather.current.feelslikeC
        taskObject.lastUpdate = weather.location.localtime
        taskObject.tempC = weather.current.tempC
        taskObject.windSpeed = weather.current.windMph
        
        do {
            try context.save()
            print("\(weather.location.name) save ✅✅✅")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteCity(_ name: String) {
        let fetchRequest: NSFetchRequest<WeatherCoreDataModel> = WeatherCoreDataModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "location == %@", name)
        
        do {
            let result = try context.fetch(fetchRequest)
            guard !result.isEmpty else { return }
            
            context.delete(result[0])
            try context.save()
            print("\(name) delete ❌❌❌")
        } catch {
            print(error.localizedDescription)
        }
    }
}
