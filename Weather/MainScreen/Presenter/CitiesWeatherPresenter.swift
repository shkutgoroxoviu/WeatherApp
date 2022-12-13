//
//  MainPresenter.swift
//  Weather
//
//  Created by Гурген Хоршикян on 20.10.2022.
//

import Foundation

protocol CitiesWeatherPresenterProtocol {
    /// Отфильтрованные модели для ячеек (используются при поиске)
    var filteredRows: [CityWeatherCellModel] { get }
    
    /// Все модели для ячеек
    var rowModels: [CityWeatherCellModel] { get set }
    
    /// Метод фильтрации моделей по тексту
    /// - Parameter searchText: текст, который вводят с клавиатуры
    func filterContentForSearchText(_ searchText: String)
    
    /// Стартовая функция
    func didLoad()
    
    /// Функция открытия экрана детальной информации
    /// - Parameter index: индекс ячейки с которой переходим
    func openDetailWeather(for index: Int)
    
    /// Функция удаления города
    /// - Parameter name: город, который надо удалить
    func deletCity(at name: String)
    
    /// Принимает название города и получает погоду из интернета
    func loadWeather(city: String)
}

final class CitiesWeatherPresenter: CitiesWeatherPresenterProtocol {
    weak var view: CitiesWeatherViewProtocol?
    
    private var service = WeatherService()
    private var coreDataService = CoreDataService()
    
    private var cities: [String] {
        return UserDefaults.cities
    }
    
    var rowModels: [CityWeatherCellModel] = []
    var filteredRows: [CityWeatherCellModel] = []
    
    private let dipsatchGroup = DispatchGroup()
    
    func didLoad() {
        loadAllCitiesWeather()
    }
    
    private func loadAllCitiesWeather() {
        for city in cities {
            dipsatchGroup.enter()
            service.fetchWeather(for: city) { [weak self] weather in
                guard let weather = weather else {
                    self?.dipsatchGroup.leave()
                    return
                }
                
                self?.coreDataService.update(with: weather)
                self?.dipsatchGroup.leave()
            }
        }
        
        dipsatchGroup.notify(queue: .main) { [weak self] in
            self?.update()
        }
    }
    
    private func update() {
        guard let dataModels = self.coreDataService.fetchWeather() else  { return }
        rowModels = dataModels.compactMap({ model in
            return CityWeatherCellModel(
                cityName: model.location,
                temperature: model.tempC,
                condtition: model.condition
            )
        })
        
        view?.reloadData()
        view?.stopActivity()
    }
    
    func addCity(at weather: Weather) {
        coreDataService.addCity(weather: weather)
        // Добавляем в массив городов, город который приходит в функцию
        UserDefaults.cities.append(weather.location.name)
        update()
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredRows = rowModels.filter { model -> Bool in
            return model.cityName.lowercased().contains(searchText.lowercased())
        }
        view?.reloadData()
    }
    

    func deletCity(at name: String) {
        coreDataService.deleteCity(name)
        // Удаляем из массива городов, город который приходит в функцию
        UserDefaults.cities.removeAll { $0 == name }
        print(cities)
        update()
    }
    
    func openDetailWeather(for index: Int) {
        let name = rowModels[index].cityName
        guard let model = coreDataService.fetchOneElement(name: name) else { return }
        let vc = DetailedScreenConfigurator.config(with: model)
        view?.openNextVC(vc: vc)
    }
    
    func loadWeather(city: String) {
        service.fetchWeather(for: city) { [weak self] weather in
            guard let weather = weather else { return }
            self?.addCity(at: weather)
        }
    }
}


