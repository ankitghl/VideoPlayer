//
//	Snippet.swift
//
//	Create by Ankit G on 30/7/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Snippet{

	var channelId : String!
	var channelTitle : String!
	var descriptionField : String!
	var liveBroadcastContent : String!
	var publishedAt : String!
	var thumbnails : Thumbnail!
	var title : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		channelId = dictionary["channelId"] as? String
		channelTitle = dictionary["channelTitle"] as? String
		descriptionField = dictionary["description"] as? String
		liveBroadcastContent = dictionary["liveBroadcastContent"] as? String
		publishedAt = dictionary["publishedAt"] as? String
		if let thumbnailsData = dictionary["thumbnails"] as? [String:Any]{
				thumbnails = Thumbnail(fromDictionary: thumbnailsData)
			}
		title = dictionary["title"] as? String
	}

}