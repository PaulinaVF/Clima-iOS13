//
//  WeatherModel.swift
//  Clima
//
//  Created by Paulina Vara on 16/08/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    //Computed property: It's a property that can change on execution time depending on other properties... for example condition name is a string which value depends on conditionId value
    var conditionName: String {
        switch conditionId {
        case 200...240:
            return "cloud.bolt.rain"
        case 300...340:
            return "cloud.drizzle"
        case 500...540:
            return "cloud.rain"
        case 600...640:
            return "cloud.snow"
        case 700...771:
            return "cloud.fog"
        case 780:
            return "tornado"
        case 800:
            return "sun.max"
        case 801...802:
            return "cloud.sun"
        case 803...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
}
