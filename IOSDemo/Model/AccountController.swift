//
//  AccountController.swift
//  IOSDemo
//
//  Created by tester on 2023/04/05.
//

import Foundation
import CoreData

class AccountController: ObservableObject {
    let container = NSPersistentContainer (name: "Account")
    @Published var account: Account
    init(){
        container.loadPersistentStores { desc, err in
            if let err = err {
                print("Fail to load the data \(err.localizedDescription)")
            }
        }
        
        fetchAccount()
    }
    
    func fetchAccount() {
        let request = NSFetchRequest<Account>(entityName: "Account")
        do {
            accounts = try container.viewContext.fetch(request)
        } catch let err {
            print("Error fetching .\(err)")
        }
        
    }
}


