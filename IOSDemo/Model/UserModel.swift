//
//  UserModel.swift
//  IOSDemo
//
//  Created by EP_NonFunc on 2023/03/23.
//

import Foundation


struct UserModel: Codable, Identifiable{
    var id:String
    var name:String
    var email: String
    var passwd: String
    
    init(id:String = UUID().uuidString, name: String, email: String, passwd: String){
        self.id = id
        self.name = name
        self.email = email
        self.passwd = passwd
    }
    
}

var users:[UserModel] = load("User.json")


