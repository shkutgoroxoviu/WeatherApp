//
//  MainScreenConfigurator.swift
//  Weather
//
//  Created by Гурген Хоршикян on 22.10.2022.
//

import Foundation
import UIKit

class MainScreenConfigurator {
    static func config() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! CitiesWeatherViewController
        let presenter = CitiesWeatherPresenter()
        vc.presenter = presenter
        presenter.view = vc
        
        return UINavigationController(rootViewController: vc)
    }
}
