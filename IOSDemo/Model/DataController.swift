//
//  DataController.swift
//  RoomOrder
//
//  Created by EP_NonFunc on 2023/03/23.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "User")
    @Published var users: [User] = []

    init() {
        container.loadPersistentStores{desc, error in
            if let error = error {
                print("Fail to load the data \(error.localizedDescription)")
            }
        }
        fetchUsers()
    }
    func save(context: NSManagedObjectContext){
        do{
            try context.save()
            fetchUsers()
            print("Data saved")

        }catch {
            print("Data could not be saved ...")
        }
    }
    func fetchUsers(){
        let request = NSFetchRequest<User>(entityName: "User")
        do {
            users = try container.viewContext.fetch(request)
        }catch let error {
            print("Error fetching .\(error)")
        }
    }
    func addUser(email: String, name: String, passwd: String, context: NSManagedObjectContext){
        let user = User(context: context)
        user.id = UUID()
        user.name = name
        //user.email = email
        //user.passwd = passwd
        save(context: context)
    }
}

