//
//  RoomRow.swift
//  IOSDemo
//
//  Created by tester on 2023/03/28.
//

import SwiftUI

struct RoomRow: View {
    @Binding var drafRoomOrder: [RoomModel]
    var room: RoomModel
    @Binding var total: Int64
    @Binding var days:Int
    @State var isBooked: Bool
    init(drafRoomOrder: Binding<[RoomModel]>,room: RoomModel, total: Binding<Int64>, days: Binding<Int>) {
        self._drafRoomOrder = drafRoomOrder
        self.room = room
        self._total = total
        self._days = days
        var checked = false
        
        for item in drafRoomOrder {
            if room.id == item.id {
                checked = true
                break
            }
        }
        isBooked = checked
        
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
                Toggle("",isOn: $isBooked).toggleStyle(iOSCheckboxToggleStyle()).font(.largeTitle)
                    .onChange(of: isBooked) { value in
                        updateDrafRoomOrder()
                    }
            }
            
        }
        
    }
    func updateDrafRoomOrder(){
        if isBooked {
            drafRoomOrder.append(room)
            total += room.price * Int64(days)
        }else {
            if let index = drafRoomOrder.firstIndex(where: {$0.id == room.id}){
                drafRoomOrder.remove(at: index)
                total = total - room.price * Int64(days)
            }
        }
        
    }
}
struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 20, height: 20)
                .padding()
                .onTapGesture { configuration.isOn.toggle() }
        }
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
