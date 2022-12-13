//
//  DetailedWeatherPresenter.swift
//  Weather
//
//  Created by Гурген Хоршикян on 26.10.2022.
//

import Foundation

protocol DetailedWeatherPresenterProtocol {
    func viewDidLoad()
}

class DetailedWeatherPresenter: DetailedWeatherPresenterProtocol {
    var view: DetailedWeatherViewProtocol?
    
    let model: WeatherCoreDataModel

    init(model: WeatherCoreDataModel) {
        self.model = model
    }
    
    func viewDidLoad() {
        view?.config(model: model)
    }
}
