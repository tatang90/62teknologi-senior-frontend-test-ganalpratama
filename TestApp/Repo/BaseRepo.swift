//
//  BaseRepo.swift
//  TestApp
//
//  Created by Icon+ Gaenael on 16/05/23.
//

import Foundation

class BaseRepo {
    var end_point = ""
    var http_method = "GET"
    private var request = URLRequest(url: URL(string: "https://api.yelp.com/v3/")!)
    private let base_url = "https://api.yelp.com/v3/"
    
    func load<T : Decodable>(type: T.Type, withCompletion completion: @escaping (T?, Error?) -> Void) {
        request = URLRequest(url: URL(string: base_url + end_point)!)
        request.allHTTPHeaderFields = getHeader()
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error { completion(nil, error); return }
            do {
                let response = try JSONDecoder().decode(T.self, from: data!)
                DispatchQueue.main.async { completion(response, nil) }
            } catch {
                DispatchQueue.main.async { completion(nil, error); return }
            }
        }
        task.resume()
    }
    
    private func getHeader() -> [String: String]{
        return [
            "accept": "application/json",
            "Authorization": "Bearer Ubf1-f0uqsJUnssqPMGo-tiFeZTT85oFmKfznlPmjDtX8s83jYMoAb-ApuD63wgq6LDZNsUXG6gurZIVYaj2jzxJmmLdCdXbDqIHU_b6KiCEVi8v-YB0OSsW6MWaY3Yx"
          ]
    }
}
