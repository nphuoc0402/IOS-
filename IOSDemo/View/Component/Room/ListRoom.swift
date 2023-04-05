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
    
    init(listRooms: Binding<[RoomModel]>, drafRoomOrder:Binding<[RoomModel]>, total: Binding<Int64>, days: Binding<Int>, isShowDetail: Binding<Bool>, detailRoomId: Binding<String>){
        self._listRooms = listRooms
        self._drafRoomOrder = drafRoomOrder
        self._total = total
        self._days = days
        self._isShowDetail = isShowDetail
        self._detailRoomId = detailRoomId
        
    }
    var body: some View {
        VStack(spacing: 0) {
            List(listRooms){ room in
                Button(action: {
                    isShowDetail = true
                    detailRoomId = room.id
                    
                }) {
//                    RoomRow(drafRoomOrder: $drafRoomOrder, room: room, total: $total, days: $days)
                }
            }
        }
        
    }

}




