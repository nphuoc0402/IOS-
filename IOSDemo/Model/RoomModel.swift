//
//  RoomModel.swift
//  IOSDemo
//
//  Created by EP_NonFunc on 2023/03/23.
//


import Foundation
struct RoomModel: Codable, Identifiable{
    var id: String
    var name: String
    var floor: String
    var price: Int64
    var type: String
    init(id:String = UUID().uuidString, name: String, floor: String, price: Int64, type: String){
        self.id = id
        self.name = name
        self.floor = floor
        self.price = price
        self.type = type
    }
    
}

var rooms: [RoomModel] = load("Room.json")

