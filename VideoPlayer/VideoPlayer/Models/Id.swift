//
//	Id.swift
//
//	Create by Ankit G on 30/7/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Id{

	var kind : String!
	var videoId : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		kind = dictionary["kind"] as? String
		videoId = dictionary["videoId"] as? String
	}

}