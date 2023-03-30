//
//  RoomRow.swift
//  IOSDemo
//
//  Created by tester on 2023/03/28.
//

import SwiftUI

struct RoomRow: View {
    var room: RoomModel
    @State var isBooked: Bool = false
    @Binding var drafRoomOrder: [RoomModel]
    init(drafRoomOrder: Binding<[RoomModel]>,room: RoomModel) {
        self._drafRoomOrder = drafRoomOrder
        self.room = room
    }
    var body: some View {
        ZStack{
            HStack{
                VStack{
                    room.image
                        .resizable()
                        .frame(width: 60, height:60)
                }
                VStack(spacing: 5){
                    Text("部屋:   \(room.name)")
                    Text("     価格: ¥\(room.price)")
                    Text("  タイプ: \(room.type)")
                }
                .font(.system(size: 12))
                Spacer()
            }
            HStack {
                Spacer()
                Toggle("",isOn: $isBooked).toggleStyle(iOSCheckboxToggleStyle()).font(.largeTitle)
                    .onChange(of: isBooked) { value in
                        updateDrafRoomOrder()
                    }
            }
            
        }
        
    }
    func updateDrafRoomOrder(){
        print("update")
        print(room.name)
        drafRoomOrder.append(room)
    }
}

struct RoomRow_Previews: PreviewProvider {
    static var previews: some View {
        Group{
//            RoomRow(room: rooms[0])   
//            RoomRow(room: rooms[1])
               
        }
        .previewLayout(.fixed(width: 350, height: 150))
        
    }
}
