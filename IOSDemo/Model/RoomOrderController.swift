//
//  RoomOrderController.swift
//  IOSDemo
//
//  Created by EP_NonFunc on 2023/03/27.
//

import Foundation
import CoreData
class RoomOrderController: ObservableObject {
    
    let viewContext = PersistenceController.shared.container.viewContext
    init() {
        for user in users {
            print(user.name)
        }
        fetchRoomOrder()
    }
    
    func fetchRoomOrder(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RoomOrder")
//        request.predicate = NSPredicate(format: "name = %@", "name")
        request.returnsObjectsAsFaults = false
        do {
            let result = try viewContext.fetch(request)
            for data in result as! [NSManagedObject]{
                print(data.value(forKey: "roomId") as! String)
            }
        }catch {
            print("Failed")
        }
    }
    func addRoomOrder(){
        let entity = NSEntityDescription.entity(forEntityName: "RoomOrder", in: viewContext)
        let newRoomOrder = NSManagedObject(entity: entity!, insertInto: viewContext)
        newRoomOrder.setValue("01", forKey: "userId")
        newRoomOrder.setValue("01", forKey: "roomId")
        newRoomOrder.setValue(Date(), forKey: "checkinDate")
        newRoomOrder.setValue(Date(), forKey: "checkoutDate")
        do {
            try viewContext.save()
        }catch{
            print("error save")
        }
    }
}
