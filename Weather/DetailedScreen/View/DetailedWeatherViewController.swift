//
//  WeatherInfoViewController.swift
//  Weather
//
//  Created by Гурген Хоршикян on 26.10.2022.
//

import Foundation
import UIKit

protocol DetailedWeatherViewProtocol {
    func config(model: WeatherCoreDataModel)
}

class DetailedWeatherViewController: UIViewController, DetailedWeatherViewProtocol {
    var presenter: DetailedWeatherPresenterProtocol?
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speedWindLabel: UILabel!
    @IBOutlet weak var feelsLikeCLabel: UILabel!
    @IBOutlet weak var localTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    func config(model: WeatherCoreDataModel) {
        cityNameLabel.text = model.location
        temperatureLabel.text = "\(model.tempC)"
        statusLabel.text = model.condition
        speedWindLabel.text = "\(model.windSpeed)"
        feelsLikeCLabel.text = "\(model.feelLike)"
        localTimeLabel.text = model.lastUpdate
    }
}
