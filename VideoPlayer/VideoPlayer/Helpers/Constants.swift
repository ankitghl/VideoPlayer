//
//  Constants.swift
//  VideoPlayer
//
//  Created by Ankit.G on 25/07/18.
//  Copyright © 2018 Ankit.Gohel. All rights reserved.
//

import Foundation
import UIKit
/*
 "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(textField.text)&type=\(type)&key=\(apiKey)"

 urlString = "https://www.googleapis.com/youtube/v3/channels?part=contentDetails,snippet&id=\(desiredChannelsArray[channelIndex])&key=\(apiKey)"
 */
struct Constants {
    struct AppVariables {
        static let appName: String = "VideoPlayer"
        static let apiError: String = "Oops! Something went wrong."
        static let jsonError: String = "Oops! Something went wrong."
    }

    struct AppURL {
        static let searchAPIURL: String = "https://www.googleapis.com/youtube/v3/search?part=snippet"
    }
    
    struct AppTheme {
        static let appThemeColor: UIColor = UIColor(red: 234/255, green: 66/255, blue: 87/255, alpha: 1)
    }
    
    struct AppURLVariables {
        static let apiKey: String = "AIzaSyCwbGziupadfpxuaTv72BsKZxOAQQDDj9A"
        static let pageCount: String = "10"
    }

    struct StoryboardNames {
        static let main: String = "Main"
    }
}



