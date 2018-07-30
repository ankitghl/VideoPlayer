//
//  NetworkWrapper.swift
//  VideoPlayer
//
//  Created by Ankit.G on 25/07/18.
//  Copyright © 2018 Ankit.Gohel. All rights reserved.
//

import Foundation

class NetworkWrapper: NSObject {
    
    var session: URLSession?
    
    //MARK: - Initialisers
    
    override init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    //MARK: - API Calls
    
    func callAPI(with urlstring: String, onSuccess:@escaping (NSDictionary)->(), onFailure:@escaping (String)->()) {
        let _url: String = urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        guard let url = URL(string: _url) else {
            DispatchQueue.main.async {
                onFailure(Constants.AppVariables.apiError)
            }
            return
        }
        let dataTask = session?.dataTask(with: url) { (responseData, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    onFailure(Constants.AppVariables.apiError)
                }
                return
            }
            guard let content = responseData else {
                DispatchQueue.main.async {
                    onFailure(Constants.AppVariables.apiError)
                }
                
                return
            }
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: [])) as? [String: Any] else {
                DispatchQueue.main.async {
                    onFailure(Constants.AppVariables.apiError)
                }
                return
            }
            if let statusDictionary = json["status"] as? [String: AnyObject],
                let statusCode = statusDictionary["code"] as? Int,
                statusCode == 0,
                let message = statusDictionary["message"] as? String {
                DispatchQueue.main.async {
                    onFailure(message)
                }
                
            } else {
                if JSONSerialization.isValidJSONObject(json) {
                    DispatchQueue.main.async {
                        onSuccess(json as NSDictionary)
                    }
                } else {
                    DispatchQueue.main.async {
                        onSuccess(NSDictionary())
                    }
                }
            }
        }
        dataTask?.resume()
    }
    
    
    func downloadImage(urlstring: String, onSuccess:@escaping (Data)->(), onFailure:@escaping (String)->()) {
        guard let url = URL(string: urlstring) else {
            DispatchQueue.main.async {
                onFailure(Constants.AppVariables.apiError)
            }
            return
        }
        
        let dataTask = session?.downloadTask(with: url) { (responseURL, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    onFailure(Constants.AppVariables.apiError)
                }
                return
            }
            
            guard let content = responseURL else {
                DispatchQueue.main.async {
                    onFailure(Constants.AppVariables.apiError)
                }
                
                return
            }
            
            do {
                let imageData = try NSData(contentsOf: content, options: NSData.ReadingOptions())
                DispatchQueue.main.async {
                    onSuccess(imageData as Data)
                }
                
            } catch {
                DispatchQueue.main.async {
                    onFailure(Constants.AppVariables.apiError)
                }
            }
        }
        dataTask?.resume()
    }    
    
}
