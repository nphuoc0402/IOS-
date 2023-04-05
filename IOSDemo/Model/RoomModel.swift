//
//  RoomModel.swift
//  IOSDemo
//
//  Created by EP_NonFunc on 2023/03/23.
//


import Foundation
import SwiftUI



struct RoomModel: Codable, Identifiable {
    var id: String
    var name: String
    var floor: String
    var price: Int64
    var type: String
    var description: String
    
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
    
    init(id:String = UUID().uuidString, name: String, floor: String, price: Int64, type: String, imageName: String, description: String){
        self.id = id
        self.name = name
        self.floor = floor
        self.price = price
        self.type = type
        self.imageName = imageName
        self.description = description
    }
    
}



