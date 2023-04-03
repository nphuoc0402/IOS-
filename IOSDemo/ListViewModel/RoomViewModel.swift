//
//  RoomViewModel.swift
//  IOSDemo
//
//  Created by EP_NonFunc on 2023/03/23.
//

import Foundation

class RoomViewModel:ObservableObject {
    @Published var rooms: [RoomModel] = []
    var roomOrderController:RoomOrderController = RoomOrderController()
    
    let roomKey :  String = "rooms_list"
    init(){
        getRooms()
//        filterRoom()
        //let results = roomOrderController.getRoomOrderByUser(userId: "01")
//        for result in results {
//            print(result.checkinDate ?? "")
//        }
        //roomOrderController.addRoomOrder()
    }
    func getRooms(){
        self.rooms = load("Room.json")
    }
    func getRoomById(id: String)-> RoomModel?{
        for room in self.rooms {
            if room.id == id {
                return room
            }
        }
        return nil
    }
    func filterRoom(checkinDate: Date, checkoutDate:Date, roomType: String) ->[RoomModel] {
        
        var roomFilter:[RoomModel] = []
        let chin = formatDateHelper(date: checkinDate)
        let chout = formatDateHelper(date: checkoutDate)
        for room in rooms {
            if(!roomOrderController.isBookingInRange(checkinDate: chin, checkoutDate: chout, roomId: room.id))
            {
                if(roomType == "全て" || room.type == roomType){
                    roomFilter.append(room)
                    
                }
            }
        }
        return roomFilter
    }
    
}
