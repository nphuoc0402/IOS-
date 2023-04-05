//
//  Account.swift
//  IOSDemo
//
//  Created by tester on 2023/04/04.
//

import Foundation
import ObjectiveC

class Account: ObservableObject {
    @Published var name: String = ""
    @Published var cardNumber: String = ""
    
    func isNameValid() -> Bool {
        let nameTest = NSPredicate(format: "SELF MATCHES %@", "^[A-Z ]+$")
        return nameTest.evaluate(with: name)
    }
    
    func isCardNumberValid() -> Bool {
        let cardNumberTest = NSPredicate(format: "SELF MATCHES %@", "^[0-9]{16}$")
        return cardNumberTest.evaluate(with: cardNumber)
    }
    
    
    var namePromt: String{
        if isNameValid() {
            return ""
        }else {
            return "カード所有者の名前は大文字にする必要があります"
        }
    }
    
    var cardNumberPromt: String {
        if isCardNumberValid() {
            return ""
        }else {
            return "カード番号は16桁である必要があります"
        }
    }
}
