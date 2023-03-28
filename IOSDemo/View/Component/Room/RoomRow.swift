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
    var body: some View {
        ZStack{
            HStack{
                room.image
                    .resizable()
                    .frame(width: 50, height:50)
                Text(room.name)
                Spacer()
            }
            
            
            HStack {
                Spacer()
                Toggle("",isOn: $isBooked).toggleStyle(iOSCheckboxToggleStyle()).font(.largeTitle)
            }
            
        }
        
    }
}

struct RoomRow_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            RoomRow(room: rooms[0])   
            RoomRow(room: rooms[1])
               
        }
        .previewLayout(.fixed(width: 300, height: 70))
        
    }
}
