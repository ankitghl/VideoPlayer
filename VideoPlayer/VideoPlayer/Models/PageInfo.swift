//
//	PageInfo.swift
//
//	Create by Ankit G on 30/7/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct PageInfo{

	var resultsPerPage : Int!
	var totalResults : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		resultsPerPage = dictionary["resultsPerPage"] as? Int
		totalResults = dictionary["totalResults"] as? Int
	}

}