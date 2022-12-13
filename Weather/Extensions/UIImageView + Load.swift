//
//  UIImageView + Load.swift
//  Weather
//
//  Created by Гурген Хоршикян on 04.11.2022.
//

import UIKit

extension UIImageView {
    func load(url: String) {
        guard let url = URL(string: "https://cdn2.iconfinder.com/data/icons/weather-flat-14/64/weather02-512.png") else { return }
        
        var request = URLRequest(url: url)
//        request.allHTTPHeaderFields = [
//            "X-RapidAPI-Key": "9e5fae83e7msh2c84a52c461378ep11ab9fjsn8204ed9d7c3a",
//            "X-RapidAPI-Host": "weatherapi-com.p.rapidapi.com"
//        ]
//
        DispatchQueue.global().async { [weak self] in
            URLSession.shared.dataTask(with: request) { data, _, _ in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
            }.resume()
        }
    }
}

struct Eblo{
    let name = "Oleg"
}

struct Adekvat {
    let name = "Gura"
    let olef = Eblo()
}
