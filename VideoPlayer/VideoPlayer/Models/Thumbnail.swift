//
//	Thumbnail.swift
//
//	Create by Ankit G on 30/7/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Thumbnail{

	var defaultField : Default!
	var high : Default!
	var medium : Default!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		if let defaultFieldData = dictionary["default"] as? [String:Any]{
				defaultField = Default(fromDictionary: defaultFieldData)
			}
		if let highData = dictionary["high"] as? [String:Any]{
				high = Default(fromDictionary: highData)
			}
		if let mediumData = dictionary["medium"] as? [String:Any]{
				medium = Default(fromDictionary: mediumData)
			}
	}

}