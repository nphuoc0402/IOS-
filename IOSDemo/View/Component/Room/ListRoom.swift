//
//  ListRoom.swift
//  IOSDemo
//
//  Created by tester on 2023/03/28.
//

import SwiftUI

struct ListRoom: View {
    @State private var selectedItem: RoomModel? = nil
    @Binding var listRooms:[RoomModel]
    @Binding var drafRoomOder: [RoomModel]
    init(listRooms: Binding<[RoomModel]>, drafRoomOrder:Binding<[RoomModel]>){
        self._listRooms = listRooms
        self._drafRoomOder = drafRoomOrder
    }
    var body: some View {
            List(listRooms){ room in
                Button(action: {
                    self.selectedItem = room
                }) {
                    RoomRow(drafRoomOrder: $drafRoomOder, room: room)
                }
            }
            .popover(item: $selectedItem){room in
                RoomDetail(room: room)
            }
    }
}

struct ListRoom_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE (2nd generation)","iPhone 14 Pro Max"], id:\.self){deviceName in
//            ListRoom()
//                .previewDevice(PreviewDevice(rawValue: deviceName))
//                .previewDisplayName(deviceName)
            
        }
    }
}
