//
//  DetailedScreenConfigurator.swift
//  Weather
//
//  Created by Гурген Хоршикян on 28.10.2022.
//

import Foundation
import UIKit

class DetailedScreenConfigurator {
    static func config(with model: WeatherCoreDataModel) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailedViewController") as! DetailedWeatherViewController
        let presenter = DetailedWeatherPresenter(model: model)
        vc.presenter = presenter
        presenter.view = vc
        return vc
    }
}
