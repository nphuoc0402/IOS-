//
//  ListOrderedView.swift
//  IOSDemo
//
//  Created by EP_NonFunc on 2023/04/03.
//

import SwiftUI

struct ListOrderedView: View {
    var roomOrderController:RoomOrderController = RoomOrderController()
    var roomViewModel : RoomViewModel = RoomViewModel()
    var listRooms:[RoomOrder] = []
    @State var checkinDate = Date()
    @State var checkoutDate = Date().addingTimeInterval(86400)
    
    init() {
        self.listRooms = roomOrderController.getRoomOrderByUser(userId: "1")
    }
    func filterData() {
    }
    var body: some View {
        ZStack{
            VStack{
                Text("支払い")
                    .font(.system(size:20))
                    .frame(alignment: .top)
                HStack{
                    DatePicker("Checkin Date",
                               selection: $checkinDate,
                               in: Date()...,
                               displayedComponents: [.date]
                    )
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .frame(maxWidth: .infinity)
                        .onChange(of: checkinDate) { value in
                            filterData()
                        }
                    Image(systemName: "arrow.right")
                        .foregroundColor(.black)
                    
                    DatePicker("",
                               selection: $checkoutDate,
                               in: (checkinDate.addingTimeInterval(86400))...,
                               displayedComponents: [.date]
                    ).labelsHidden()
                        .datePickerStyle(.compact)
                        .frame(maxWidth: .infinity)
                        .onChange(of: checkoutDate) { value in
                            filterData()
                        }
                }.padding()
                VStack(alignment: .leading){
                    List{
                        
                        ForEach(self.listRooms, id:\.self) { orderRoom in
                            let room = roomViewModel.getRoomById(id: orderRoom.roomId ?? "")
                            HStack{
                                VStack{
                                    room?.image
                                        .resizable()
                                        .frame(width: 60, height:60)
                                }
                                VStack(spacing: 5){
                                    Text("     価格: ¥\(room?.name ?? "")")
                                }
                                .font(.system(size: 12))
                                Spacer()
                            }
                            
                        }
                        
                    }.cornerRadius(5)
                        .padding(.horizontal,20)
                }
                
                
            }
            
            Spacer()
        }.frame(alignment: .top)
    }
}
