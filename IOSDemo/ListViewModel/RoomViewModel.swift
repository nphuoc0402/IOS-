//
//  RoomViewModel.swift
//  IOSDemo
//
//  Created by EP_NonFunc on 2023/03/23.
//

import Foundation

class RoomViewModel:ObservableObject {
    @Published var rooms: [RoomModel] = []
    
    
    let roomKey :  String = "rooms_list"
    init(){
        getRooms()
    }
    func getRooms(){
        self.rooms = load("Room.json")
    }
}
