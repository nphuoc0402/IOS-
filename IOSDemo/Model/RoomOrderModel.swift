//
//  RoomOrderModel.swift
//  IOSDemo
//
//  Created by EP_NonFunc on 2023/03/23.
//

import Foundation
struct RoomOrderModel:Codable, Identifiable {
    var id: String
    var userId: String
    var roomId: String
    var checkinDate: Date
    var checkoutDate: Date
    var paymentMethod: String
    
    init(id:String = UUID().uuidString, userId: String, roomId: String, checkinDate: Date, checkoutDate: Date, paymentMethod: String){
        self.id = id
        self.userId = userId
        self.roomId = roomId
        self.checkinDate = checkinDate
        self.checkoutDate = checkoutDate
        self.paymentMethod = paymentMethod
    }
}
