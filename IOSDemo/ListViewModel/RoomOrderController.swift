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
        //deleteRoomOrder()
    }

    func getRoomOrderByUser(userId: String) -> [RoomOrder] {
        let request = NSFetchRequest<RoomOrder>(entityName: "RoomOrder")
        let dateSort = NSSortDescriptor(key: "orderDate", ascending: false)
        request.predicate = NSPredicate(format: "userId = %@", userId)
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [dateSort]
        var results:[RoomOrder] = []
        do {
            results = try viewContext.fetch(request)
        }catch {
            print("Failed")
        }
        return results
    }
    func getRoomOrderByUserInRange(userId: String, checkinDate: Date, checkoutDate: Date) -> [RoomOrder] {
        let request = NSFetchRequest<RoomOrder>(entityName: "RoomOrder")
        let dateSort = NSSortDescriptor(key: "orderDate", ascending: false)
        request.predicate = NSPredicate(format: "userId = %@", userId)
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [dateSort]
        var results:[RoomOrder] = []
        do {
            results = try viewContext.fetch(request)
            for data in results {
                if (!(checkinDate <= data.value(forKey: "checkoutDate") as! Date && checkoutDate >= data.value(forKey: "checkinDate") as! Date)) {
                    results.removeAll(where: { $0.roomId == data.value(forKey: "roomId") as? String})
                }
            }
            
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
                if (checkinDate < data.value(forKey: "checkoutDate") as! Date && checkoutDate > data.value(forKey: "checkinDate") as! Date) {
                    return true
                }
            }
        }catch {
            print("Failed")
        }
        return false
    }
    
    func deleteRoomOrder(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RoomOrder")
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try viewContext.execute(batchDeleteRequest1)
        }catch {
            print("Failed")
        }
    }
}
