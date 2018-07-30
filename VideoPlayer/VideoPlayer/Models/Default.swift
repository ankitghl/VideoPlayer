//
//	Default.swift
//
//	Create by Ankit G on 30/7/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Default{

	var height : Int!
	var url : String!
	var width : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		height = dictionary["height"] as? Int
		url = dictionary["url"] as? String
		width = dictionary["width"] as? Int
	}

}