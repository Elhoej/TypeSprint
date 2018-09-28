//
//  NetworkManager.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 27/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation

class NetworkManager: NSObject
{
    static let shared = NetworkManager()
    
    private let apiKey = "iq_ehxXDDhfU2WURflej8QeF"
    private let baseURL = URL(string: "http://quotes.rest/quote/random.json")!
    
    func fetchRandomQuote(completion: @escaping (Error?, Quote?) -> ())
    {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let minLengthQueryItem = URLQueryItem(name: "minlength", value: "150")
        let maxLengthQueryItem = URLQueryItem(name: "maxlength", value: "250")
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: apiKey)
        urlComponents?.queryItems = [minLengthQueryItem, maxLengthQueryItem, apiKeyQueryItem]
        
        guard let urlRequest = urlComponents?.url else {
            NSLog("Failed to create url request")
            completion(NSError(), nil)
            return
        }
        
        guard let secureUrl = urlRequest.usingHTTPS else {
            NSLog("Couldn't use HTTPS")
            completion(NSError(), nil)
            return
        }
        
        var request = URLRequest(url: secureUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error
            {
                NSLog("Error fetching quote: \(error)")
                completion(error, nil)
                return
            }
            
            guard let data = data else {
                NSLog("Error unwrapping data")
                completion(NSError(), nil)
                return
            }
            
            do {
                
                let jsonDecoder = JSONDecoder()
                let quote = try jsonDecoder.decode(Quote.self, from: data)
                completion(nil, quote)
                
            } catch let error {
                NSLog("Error decoding data: \(error)")
                completion(error, nil)
                return
            }
        }.resume()
    }
}
