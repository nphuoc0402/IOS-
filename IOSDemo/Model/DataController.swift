//
//  DataController.swift
//  RoomOrder
//
//  Created by EP_NonFunc on 2023/03/23.
//

import Foundation
import CoreData
import UIKit

class DataController: ObservableObject {
    
    let viewContext = PersistenceController.shared.container.viewContext
    
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let container = NSPersistentContainer(name: "User")
    @Published var users: [User] = []
    
    init() {
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
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
//        request.predicate = NSPredicate(format: "name = %@", "name")
        request.returnsObjectsAsFaults = false
        do {
            let result = try viewContext.fetch(request)
            for data in result as! [NSManagedObject]{
                print(data.value(forKey: "name") as! String)
            }
        }catch {
            print("Failed")
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

