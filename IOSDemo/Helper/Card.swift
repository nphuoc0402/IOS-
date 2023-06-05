//
//  Account.swift
//  IOSDemo
//
//  Created by tester on 2023/04/04.
//

import Foundation
import ObjectiveC

class Card: ObservableObject {
    @Published var name: String = ""
    @Published var cardNumber: String = ""
    @Published var expiredDate: String = ""
    @Published var secureCode: String = ""
    
    
    func isNameValid() -> Bool {
        let nameTest = NSPredicate(format: "SELF MATCHES %@", "^[A-Z ]+$")
        return nameTest.evaluate(with: name)
    }
    
    func isCardNumberValid() -> Bool {
        let cardNumberTest = NSPredicate(format: "SELF MATCHES %@", "^\\d{4}\\s\\d{4}\\s\\d{4}\\s\\d{4}$")
        return cardNumberTest.evaluate(with: cardNumber)
    }
    
    func isExpiredDateValid() -> Bool {
        let expiredDateTest = NSPredicate(format: "SELF MATCHES %@", "^\\d{2}\\/\\d{2}")
        return expiredDateTest.evaluate(with: expiredDate)
    }
    
    func isSecureCodeValid() -> Bool {
        let secureCodeText = NSPredicate(format: "SELF MATCHES %@", "^\\d{3}$")
        return secureCodeText.evaluate(with: secureCode)
    }
    
    
    var namePromt: String{
        if isNameValid() {
            return ""
        }else {
            if (name == ""){
                return "カード名様を入力してください"
            }
            return "カード所持者の名前は大文字にする必要があります"
        }
    }
    
    var cardNumberPromt: String {
        if isCardNumberValid() {
            return ""
        }else {
            return "カード番号は16桁である必要があります"
        }
    }
    
    var expiredDatePromt: String {
        if isExpiredDateValid() {
            return ""
        } else {
            return "有効期限を入力してください"
        }
    }
    
    var secureCodePromt: String {
        if isSecureCodeValid() {
            return ""
        } else {
            return "3桁のセキュリティコードを入力してください"
        }
           
    }
    
    
}
