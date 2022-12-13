//
//  InfoCell.swift
//  Weather
//
//  Created by Гурген Хоршикян on 17.10.2022.
//

import UIKit

class CityWeatherCell: UITableViewCell {

    static var reuseID = "CityWeatherCell"
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var statusWeatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
    
    func configUI() {
        statusWeatherLabel.textColor = .gray
    }
    
    func config(with model: CityWeatherCellModel) {
        cityLabel.text = model.cityName
        statusWeatherLabel.text = model.condtition
        temperatureLabel.text = "\(model.temperature) C°"
    }
}


