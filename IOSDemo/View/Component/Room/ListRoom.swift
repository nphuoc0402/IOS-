//
//  ListRoom.swift
//  IOSDemo
//
//  Created by tester on 2023/03/28.
//

import SwiftUI

struct ListRoom: View {
    @Binding var listRooms:[RoomModel]
    @Binding var drafRoomOrder:[RoomModel]
    @Binding var total: Int64
    @Binding var days: Int
    @Binding var isShowDetail: Bool
    @Binding var detailRoomId: String
    @State var name:String = ""
    @State var price:Int64 = 0
    @State var floor: String = ""
    @State var type: String = ""
    @State var image:Image = Image("")
    @State var desc: String = ""
    
    
    init(listRooms: Binding<[RoomModel]>, drafRoomOrder:Binding<[RoomModel]>, total: Binding<Int64>, days: Binding<Int>, isShowDetail: Binding<Bool>, detailRoomId: Binding<String>){
        self._listRooms = listRooms
        self._drafRoomOrder = drafRoomOrder
        self._total = total
        self._days = days
        self._isShowDetail = isShowDetail
        self._detailRoomId = detailRoomId
        loadData()
    }
    var body: some View {
        VStack(spacing: 0) {
            List(listRooms){ room in
                Button(action: {
                    name = room.name
                    price = room.price
                    floor = room.floor
                    type = room.type
                    image = room.image
                    desc = room.description
                    print(isShowDetail)
                    isShowDetail = true
                    detailRoomId = room.id
                    
                }) {
                    RoomRow(drafRoomOrder: $drafRoomOrder, room: room, total: $total, days: $days)
                }
            }
        }
        
    }
    func loadData(){
        if total == 0 {
            drafRoomOrder.removeAll()
        }
    }
}




