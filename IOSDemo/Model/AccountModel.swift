//
//  AccountModel.swift
//  IOSDemo
//
//  Created by tester on 2023/04/05.
//

import Foundation

struct AccountModel: Codable  {
    var name:String
    var card_number: String
    
    init(name: String, card_number: String){
        self.name = name
        self.card_number = card_number
    }
}
