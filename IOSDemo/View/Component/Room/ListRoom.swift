//
//  ListRoom.swift
//  IOSDemo
//
//  Created by tester on 2023/03/28.
//

import SwiftUI

struct ListRoom: View {
    @State private var selectedItem: RoomModel? = nil
    var body: some View {
            List(rooms){ room in
                Button(action: {
                    self.selectedItem = room
                }) {
                    RoomRow(room: room)
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
            ListRoom()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
            
        }
    }
}
