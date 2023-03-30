//
//  ListRoom.swift
//  IOSDemo
//
//  Created by tester on 2023/03/28.
//

import SwiftUI

struct ListRoom: View {
    
    @Binding var listRooms:[RoomModel]
    @Binding var drafRoomOder: [RoomModel]
    @Binding var total: Int64
    @State var isShowDetail = false
    @State var name:String = ""
    @State var price:Int64 = 0
    @State var floor: String = ""
    @State var type: String = ""
    @State var image:Image = Image("")
    @State var desc: String = ""
    
    init(listRooms: Binding<[RoomModel]>, drafRoomOrder:Binding<[RoomModel]>, total: Binding<Int64>){
        self._listRooms = listRooms
        self._drafRoomOder = drafRoomOrder
        self._total = total
    }
    var body: some View {
        ZStack {
            List(listRooms){ room in
                Button(action: {
                    name = room.name
                    price = room.price
                    floor = room.floor
                    type = room.type
                    image = room.image
                    desc = room.description
                    isShowDetail = true
                }) {
                    RoomRow(drafRoomOrder: $drafRoomOder, room: room, total: $total)
                }
            }
            if isShowDetail {
                PopupView(isShowDetail: $isShowDetail, name: name, price: price, floor: floor, type: type, image: image, desc: desc)
            }
        }
        
    }
}

struct PopupView: View {
    @Binding var isShowDetail: Bool
    var name: String
    var price: Int64
    var floor: String
    var type: String
    var image: Image
    var desc: String
    
    init(isShowDetail: Binding<Bool>, name: String, price: Int64, floor: String, type: String,image: Image, desc: String) {
        self._isShowDetail = isShowDetail
        self.name = name
        self.price = price
        self.floor = floor
        self.type = type
        self.image = image
        self.desc = desc
        
    }
    var body: some View {
        VStack {
            HStack{
                VStack{
                    image
                        .resizable()
                        .frame(width: 60, height:60)
                }
                VStack(spacing: 5){
                    Text("部屋:   \(name)")
                    Text("価格: ¥\(price)")
                    Text("タイプ: \(type)")
                    Text("タイプ: \(floor)")
                    Text("タイプ: \(desc)")
                }
                .font(.system(size: 15))
                .frame(alignment: .leading)
                Spacer()
            }
            HStack {
                
                Button("Ok") {
                    isShowDetail = false
                }.frame(width: UIScreen.main.bounds.width/2-30, height: 40)
                    .foregroundColor(.white)
                
            }
            
        }
        .frame(width: UIScreen.main.bounds.width-50, height: 200)
        .background(Color.blue)
        .cornerRadius(12)
        .clipped()
        
    }
    
}


