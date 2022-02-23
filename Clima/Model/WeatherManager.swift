//
//  WeatherManager.swift
//  Clima
//
//  Created by Paulina Vara on 15/08/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherSupport {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError (_ weatherManager: WeatherManager, error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1788f7ed1c0384411d5651c83b1a5975&units=metric"
    var delegate: WeatherSupport? = nil
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitud:CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitud)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create a URLSession
                //URLSession is the thing that can perform the networking (like a browser)
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
                //Create a task that retrieves the contents of the specified URL, then calls a handler upon completion
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(self, error: error!)
                    return //Cuando no dice nada después de un return no quiere decir que devuelvas nada, si no que es un "break" de la función para forzar la salida
                }
                
                if let safeData = data {
                    //Inside a closure, if we call a function from the current struct we must use the self keyword
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            //La función decode no pide al objeto WeathrData, pide al tipo, por eso agregamos el .self
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(self, error: error)
            return nil
        }
    }
    
    
    
}
