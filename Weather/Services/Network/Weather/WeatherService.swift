//
//  WeatherService.swift
//  Weather
//
//  Created by Гурген Хоршикян on 25.10.2022.
//

import Foundation


class WeatherService {
    
    private let host = "https://weatherapi-com.p.rapidapi.com/"
    private let headers = [
        "X-RapidAPI-Key": "9e5fae83e7msh2c84a52c461378ep11ab9fjsn8204ed9d7c3a",
        "X-RapidAPI-Host": "weatherapi-com.p.rapidapi.com"
    ]
    
    func fetchWeather(for city: String, complitions: @escaping (Weather?) -> Void) {
        let urlString = host + "forecast.json?q=\(city)&days=3"
        guard let url = URL(string: urlString) else { return }
        
        var requst = URLRequest(url: url)
        requst.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: requst) { data, respone, error in
            guard let data = data else {
                print(error?.localizedDescription)
                return
            }
            
            let model = self.parseJson(data: data)
            complitions(model)
            
        }.resume()
    }
    
    func parseJson(data: Data) -> Weather? {
        do {
            let model = try JSONDecoder().decode(Weather.self, from: data)
            return model
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func loadImageData(with urlString: String, complition: @escaping (Data) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, error, _ in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
            complition(data)
        }
    }
}

//    var components = URLComponents()
//        components.scheme = "https"
//        components.host = "api.github.com"
//        components.path = "/search/repositories"
//        components.queryItems = [
//            URLQueryItem(name: "q", value: query),
//            URLQueryItem(name: "sort", value: sorting.rawValue)
//        ]
    

