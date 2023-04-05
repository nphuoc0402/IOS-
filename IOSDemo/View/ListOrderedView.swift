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
    
    init() {
        self.listRooms = roomOrderController.getRoomOrderByUser(userId: "1")
    }
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
        if(checkinDate >= checkoutDate || checkout == ""){
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
                    HStack{
                        Image(systemName: "calendar").foregroundColor(.gray)
                        TextField("Start Date", text: $checkin)
                            .disabled(true)
                            
                    }
                    .frame(width: 140, height: 35)
                    .padding([.leading], 5)
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
                    
                    HStack{
                        Image(systemName: "calendar").foregroundColor(.gray)
                        TextField("To Date", text: $checkout)
                            .disabled(true)
                            
                    }
                    .frame(width: 140, height: 35)
                    .padding([.leading], 5)
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
                    
                }.padding(.bottom, 30)
                
                
            }
            if isOpenCheckin {
                VStack(spacing: 15) {
                    DatePicker("Checkin Date",
                               selection: $checkinDate,
                               displayedComponents: [.date]
                               
                    )
                        .labelsHidden()
                        .datePickerStyle(.graphical)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(20)
                        .border(.gray,width:1)
                    
                        .onChange(of: checkinDate) { value in
                            changedCheckin()
                            isPickCheckin = true
                        }
                    
                    Button(action: {
                        isOpenCheckin.toggle()
                    }, label: {
                        Text("Close")
                    }).font(.system(size:16))
                        .foregroundColor(.white)
                        .padding(.horizontal,20)
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(20)
                    
                }.cornerRadius(5)
                    .padding(30)
                    .background(Color.white)
            }
            if isOpenCheckout {
                VStack(spacing: 15) {
                    DatePicker("Checkout Date",
                               selection: $checkoutDate,
                               in: (checkinDate.addingTimeInterval(86400))...,
                               displayedComponents: [.date]
                               
                    )
                        .labelsHidden()
                        .datePickerStyle(.graphical)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(20)
                        .border(.gray,width:1)
                        .onChange(of: checkoutDate) { value in
                            changedCheckout()
                        }
                        .transition(.slide)
                    
                    Button(action: {
                        isOpenCheckout.toggle()
                    }, label: {
                        Text("Close")
                    }).font(.system(size:16))
                        .foregroundColor(.white)
                        .padding(.horizontal,20)
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(20)
                    
                }.cornerRadius(5)
                    .padding(30)
                    .background(Color.white)
            }
            
            
            
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
                let total = Int64(room?.price ?? 0) * Int64(numberOfDaysBetween(start: orderRoom.checkinDate!, end: orderRoom.checkoutDate!))
                HStack{
                    VStack{
                        room?.image
                            .resizable()
                            .frame(width: 60, height:60)
                    }
                    VStack(spacing: 5){
                        HStack {
                            Text("部屋: \(room?.name ?? "")").frame(width: 120,alignment: .leading)
                            Text("価格: ¥\(room?.price ?? 0)").frame(width: 120,alignment: .leading)
                        }
                        HStack {
                            Text("部屋: \(formatDate(date: orderRoom.checkinDate!))").frame(width: 120,alignment: .leading)
                            Text("価格: \(formatDate(date: orderRoom.checkoutDate!))").frame(width: 120,alignment: .leading)
                        }
                        HStack {
                            Text("予約日: \(room?.type ?? "")").frame(width: 120,alignment: .leading)
                            Text("支払方法: \(room?.floor ?? "")").frame(width: 120,alignment: .leading)
                        }
                        HStack {
                            Text("予約日: ¥\(total)").frame(width: 120,alignment: .leading)
                            Text("支払方法: \(formatDate(date: orderRoom.orderDate!))").frame(width: 120,alignment: .leading)
                        }
                        
                        
                    }
                    .font(.system(size: 12))
                    Spacer()
                }
                
            }
            
        }.cornerRadius(5)
            .padding(.horizontal,20)
            .padding(.vertical, 0)
        
    }
}

