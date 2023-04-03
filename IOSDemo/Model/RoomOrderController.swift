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
        fetchRoomOrder()
    }
    
    func fetchRoomOrder(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RoomOrder")
//        request.predicate = NSPredicate(format: "name = %@", "name")
        request.returnsObjectsAsFaults = false
        do {
            let result = try viewContext.fetch(request)
//            for data in result as! [NSManagedObject]{
//                print(data.value(forKey: "roomId") as! String)
//                print(data.value(forKey: "checkinDate") as! Date)
//                print(data.value(forKey: "checkoutDate") as! Date)
//            }
        }catch {
            print("Failed")
        }
    }
    func getRoomOrderByUser(userId: String) -> [RoomOrder] {
        let request = NSFetchRequest<RoomOrder>(entityName: "RoomOrder")
        request.predicate = NSPredicate(format: "userId = %@", userId)
        request.returnsObjectsAsFaults = false
        var results:[RoomOrder] = []
        do {
            results = try viewContext.fetch(request)
        }catch {
            print("Failed")
        }
        return results
    }
    
    func addRoomOrder(userId: String, roomId: String, checkinDate: Date, checkoutDate: Date, payment: Bool){
        let entity = NSEntityDescription.entity(forEntityName: "RoomOrder", in: viewContext)
        let newRoomOrder = NSManagedObject(entity: entity!, insertInto: viewContext)
        newRoomOrder.setValue(userId, forKey: "userId")
        newRoomOrder.setValue(roomId, forKey: "roomId")
        newRoomOrder.setValue(formatDateHelper(date: checkinDate), forKey: "checkinDate")
        newRoomOrder.setValue(formatDateHelper(date: checkoutDate), forKey: "checkoutDate")
        newRoomOrder.setValue(payment, forKey: "payment")
        newRoomOrder.setValue(Date(), forKey: "orderDate")
        do {
            try viewContext.save()
        }catch{
            print("error save")
        }
    }
    func isBookingInRange(checkinDate: Date, checkoutDate: Date, roomId: String) -> Bool{

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RoomOrder")
        request.predicate = NSPredicate(format: "roomId = %@", roomId)
        request.returnsObjectsAsFaults = false
        do {
            let result = try viewContext.fetch(request)
            for data in result as! [NSManagedObject]{
                if (checkinDate <= data.value(forKey: "checkoutDate") as! Date && checkoutDate >= data.value(forKey: "checkinDate") as! Date) {
                    return true
                }
                
            }
        }catch {
            print("Failed")
        }
        return false
    }
}
