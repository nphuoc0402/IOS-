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
    @State var listRooms:[RoomOrder] = []
    @State var checkinDate:Date = Date()
    @State var date:Date? = nil
    @State var checkoutDate = Date().addingTimeInterval(86400)
    @State var isOpenCheckin = false
    @State var isOpenCheckout = false
    @State private var checkin:String = ""
    @State private var checkout:String = ""
    @State var isPickCheckin: Bool = false
    @State var isPickCheckout: Bool = false
    @State var isFirst: Bool = true

    func filterData() {
        if isPickCheckin && isPickCheckout {
            listRooms = roomOrderController.getRoomOrderByUserInRange(userId: "1", checkinDate: checkinDate, checkoutDate: checkoutDate)
        }
        isFirst = false
    }
    func changedCheckin() {
        checkin = formatDate(date: checkinDate)
        isOpenCheckin.toggle()
        isOpenCheckin = false
        if(checkinDate >= checkoutDate) {
            checkoutDate = checkinDate.addingTimeInterval(86400)
            checkout = formatDate(date: checkoutDate)
        }
        
    }
    func changedCheckout() {
        isPickCheckout = true
        isOpenCheckout.toggle()
        checkout = formatDate(date: checkoutDate)
        isOpenCheckout = false
        
        
    }
    func onExpandCheckin() {
        isOpenCheckin.toggle()
    }
    func onExpandCheckout() {
        isOpenCheckout.toggle()
    }
    var body: some View {
        ZStack{
            VStack{
                Text("支払い")
                    .font(.system(size:20))
                    .frame(alignment: .top)
                
                
                HStack{
                    TextField("From Date", text: $checkin)
                        .disabled(true)
                        .padding()
                        .frame(width: 150, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .onTapGesture {
                            
                            self.onExpandCheckin()
                            isOpenCheckin = true
                            if isOpenCheckout {
                                isOpenCheckout.toggle()
                            }
                        }
                    
                    
                    Image(systemName: "arrow.right")
                        .foregroundColor(.black)
                    TextField("To Date", text: $checkout)
                        .disabled(true)
                        .padding()
                        .frame(width: 150, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .onTapGesture {
                            
                            self.onExpandCheckout()
                            isOpenCheckout = true
                            if isOpenCheckin {
                                isOpenCheckin.toggle()
                            }
                        }
                    Image(systemName: "magnifyingglass").font(.title).onTapGesture {
                        filterData()
                    }
                    
                }.padding()
                VStack(alignment: .leading){
                    if isFirst {
                        ListDataView(listRooms: roomOrderController.getRoomOrderByUser(userId: "1"), roomViewModel: roomViewModel)
                    } else {
                        ListDataView(listRooms: listRooms, roomViewModel: roomViewModel)
                    }
                    
                }
                
                
            }
            VStack {
                if isOpenCheckin {
                    DatePicker("Checkin Date",
                               selection: $checkinDate,
                               displayedComponents: [.date]
                               
                    )
                        .labelsHidden()
                        .datePickerStyle(.graphical)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(20)
                        .border(.gray,width:2)
                    
                        .onChange(of: checkinDate) { value in
                            changedCheckin()
                            isPickCheckin = true
                        }
                }
                if isOpenCheckout {
                    DatePicker("Checkout Date",
                               selection: $checkoutDate,
                               in: (checkinDate.addingTimeInterval(86400))...,
                               displayedComponents: [.date]
                               
                    )
                        .labelsHidden()
                        .datePickerStyle(.graphical)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(20)
                        .border(.gray,width:2)
                    
                        .onChange(of: checkoutDate) { value in
                            changedCheckout()
                        }
                        
                }
            }.background(Color.white)
                .cornerRadius(5)
                .padding()
                
            Spacer()
        }.frame(alignment: .top)
    }
}


struct ListDataView: View {
    var listRooms: [RoomOrder]
    var roomViewModel: RoomViewModel
    var body: some View {
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
                        Text(formatDate(date: orderRoom.checkinDate!))
                        Text(formatDate(date: orderRoom.checkoutDate!))
                    }
                    .font(.system(size: 12))
                    Spacer()
                }
                
            }
            
        }.cornerRadius(5)
            .padding(.horizontal,20)
        
    }
}
