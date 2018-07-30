//
//  ChannelAPI.swift
//  VideoPlayer
//
//  Created by Ankit.G on 30/07/18.
//  Copyright © 2018 Ankit.Gohel. All rights reserved.
//

import UIKit

struct ChannelAPI {
    
    private let baseURL: String = "\(Constants.AppURL.searchAPIURL)"
    private let apiKey: String = Constants.AppURLVariables.apiKey
    private var pageCount: String = Constants.AppURLVariables.pageCount
    private var channelID: String = ""
    private var pageToken: String = ""

    init(channelID: String, pageToken: String) {
        self.channelID = channelID
        self.pageToken = pageToken
    }

    func getURL() -> String {
        let urlString: String = "\(baseURL)&channelId=\(channelID)&maxResults=\(pageCount)&key=\(apiKey)&pageToken=\(pageToken)"
        return urlString
    }
    
}
