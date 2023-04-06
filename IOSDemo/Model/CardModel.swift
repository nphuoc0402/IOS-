//
//  AccountModel.swift
//  IOSDemo
//
//  Created by tester on 2023/04/05.
//

import Foundation

struct CardModel: Codable  {
    var name:String
    var card_number: String
    var expired_date: String
    var secure_code: String
    
    init(name: String, card_number: String, expired_date: String, secure_code: String){
        self.name = name
        self.card_number = card_number
        self.expired_date = expired_date
        self.secure_code = secure_code
    }
}
