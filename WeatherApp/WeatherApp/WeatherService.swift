//
//  WeatherService.swift
//  WeatherApp
//
//  Created by codeL on 2025/2/9.
//

import Foundation

struct WeatherData: Codable {
    let hourly: HourlyData
}

struct HourlyData: Codable {
    let time: [String]
    let temperature_2m: [Double]
}

class WeatherService {
    static func fetchWeatherData(completion: @escaping (Result<WeatherData, Error>) -> Void) {
        guard let location = LocationManager.shared.currentLocation else {
            completion(.failure(LocationError.locationUnavailable))
            return
        }
        let latitude = location.latitude
        let longitude = location.longitude
//        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(52.52)&longitude=\(13.41)&hourly=temperature_2m"
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m&forecast_days=1"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                completion(.success(weatherData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

enum LocationError: Error {
    case locationUnavailable
}

enum NetworkError: Error {
    case invalidURL
    case noData
}
