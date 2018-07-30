//
//	Item.swift
//
//	Create by Ankit G on 30/7/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Item{

	var etag : String!
	var id : Id!
	var kind : String!
	var snippet : Snippet!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		etag = dictionary["etag"] as? String
		if let idData = dictionary["id"] as? [String:Any]{
				id = Id(fromDictionary: idData)
			}
		kind = dictionary["kind"] as? String
		if let snippetData = dictionary["snippet"] as? [String:Any]{
				snippet = Snippet(fromDictionary: snippetData)
			}
	}

}