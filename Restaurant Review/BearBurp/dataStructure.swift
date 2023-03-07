//
//  dataStructure.swift
//  JiarongLiang-Lab4
//
//  Created by W Q on 10/30/22.
//

import UIKit

struct restaurantAPIData:Decodable {
    let success: Bool
    var message: [Restaurant]
}

struct foodAPIData:Decodable {
    let success: Bool
    var message: [Food]
}

struct reviewAPIData:Decodable {
    let success: Bool
    var message: [Review]
}

struct addReviewAPIData: Decodable{
    let success: Bool
    let message: String
}

struct Restaurant:Decodable,Encodable{
    let id : Int
    let name : String
    let rating : Float
    let location : String
    let image_url : String
    let longitude : Double
    let latitude : Double
}

struct Food:Decodable{
    let id: Int
    let rid:Int
    let name:String
    let rating:Float
    let price:Float
}

struct Review:Decodable {
    let id: Int
    let username:String
    let restaurantName:String
    let content:String
    let rating:Float
}

struct User:Decodable {
    let id: Int
    let username:String
    let password:String
}

struct Message:Decodable {
    let success:Bool
    let message:String
}


