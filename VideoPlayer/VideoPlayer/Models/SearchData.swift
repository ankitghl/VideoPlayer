//
//    SearchData.swift
//
//    Create by Ankit G on 30/7/2018
//    Copyright © 2018. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct SearchData{
    
    var etag : String!
    var items : [Item]!
    var kind : String!
    var nextPageToken : String!
    var pageInfo : PageInfo!
    var prevPageToken : String!
    var regionCode : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        etag = dictionary["etag"] as? String
        items = [Item]()
        if let itemsArray = dictionary["items"] as? [[String:Any]]{
            for dic in itemsArray{
                let value = Item(fromDictionary: dic)
                items.append(value)
            }
        }
        kind = dictionary["kind"] as? String
        nextPageToken = dictionary["nextPageToken"] as? String
        if let pageInfoData = dictionary["pageInfo"] as? [String:Any]{
            pageInfo = PageInfo(fromDictionary: pageInfoData)
        }
        prevPageToken = dictionary["prevPageToken"] as? String
        regionCode = dictionary["regionCode"] as? String
    }
    
}
