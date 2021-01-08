//
//  NetworkService.swift
//  ImageSearch
//
//  Created by Костина Вероника  on 07.01.2021.
//

import UIKit

class NetworkService {
    private init() {}

    static let shared = NetworkService()
    
    private let apiKey = "AIjEbPpxvP8JvssuFc4H_i2jPjXgqzD1xry0KtDLTJE"
    
    private var baseUrlComponent: URLComponents {
        var _urlComps = URLComponents(string: "https://api.unsplash.com")!
        _urlComps.path = "/search/photos/"
        _urlComps.queryItems = [
            URLQueryItem(name: "client_id", value: apiKey)
        ]
        return _urlComps
    }
    
    //MARK:- Load Image
    func loadImage(from url: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url = url else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            DispatchQueue.main.async {
                if let data = data {
                    completion(UIImage(data: data))
                } else {
                    completion(nil)
                }
            }
            
        }.resume()
        
    }
    func fetchImages(amount:Int, completion: @escaping (Result<[ImageInfo], SessionError>) -> Void) {
        var urlComps = baseUrlComponent
        urlComps.queryItems? += [
            URLQueryItem(name: "per_page", value: "\(amount)"),
            URLQueryItem(name: "query", value: "dog"),
            URLQueryItem(name: "orientation", value: "squarish")
        ]
        
        guard let url = urlComps.url else {
            completion(.failure(.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.other(error)))
                }
                return
            }
            
            let response = response as! HTTPURLResponse
            guard let data = data, response.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(.serverError(response.statusCode)))
                }
                return
            }
            
            do {
                let serverResponse = try JSONDecoder().decode(ServerResponse<ImageInfo>.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(serverResponse.results))
                }
            }
            
            catch let decodingError {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(decodingError)))
                }
        }
        }.resume()
     
    }
}
