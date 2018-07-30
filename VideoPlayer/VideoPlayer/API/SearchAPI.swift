//
//  SearchAPI.swift
//  VideoPlayer
//
//  Created by Ankit.G on 30/07/18.
//  Copyright © 2018 Ankit.Gohel. All rights reserved.
//

import Foundation

struct SearchAPI {
    
    private let baseURL: String = "\(Constants.AppURL.searchAPIURL)"
    private let apiKey: String = Constants.AppURLVariables.apiKey
    private var searchTerm: String = "Berlin"
    private var pageCount: String = Constants.AppURLVariables.pageCount
    private var pageToken: String = ""

    
    init(searchTerm: String, pageToken: String) {
        if !searchTerm.isEmpty {
            self.searchTerm = searchTerm
        }
        self.pageToken = pageToken
    }
    
    func getURL() -> String {
        let urlString: String = "\(baseURL)&q=\(searchTerm)&maxResults=\(pageCount)&pageToken=\(pageToken)&key=\(apiKey)"
        return urlString
    }

}
