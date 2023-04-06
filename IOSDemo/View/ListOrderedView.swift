//
//  ListOrderedView.swift
//  IOSDemo
//
//  Created by EP_NonFunc on 2023/04/03.
//

import SwiftUI

struct ListOrderedView: View {
    @EnvironmentObject var opDat:OpDat
    @AppStorage("userId") var userId:String = ""
    @AppStorage("isLoggedIn") var isLoggedIn:Bool = false
    var roomOrderController:RoomOrderController = RoomOrderController()
    var roomViewModel : RoomViewModel = RoomViewModel()
    @State var listRooms:[RoomOrder] = []
    @State var checkinDate:Date = Date()
    @State var date:Date? = nil
    @State var checkoutDate = Date().addingTimeInterval(86401)
    @State var isOpenCheckin = false
    @State var isOpenCheckout = false
    @State private var checkin:String = ""
    @State private var checkout:String = ""
    @State var isPickCheckin: Bool = false
    @State var isPickCheckout: Bool = false
    @State var isFirst: Bool = true
    @State var selectedOption:Int = 0
    let option = ["All Records","Custom Search Range"]
    
    func filterData() {
        
        if isPickCheckin && isPickCheckout {
            listRooms = roomOrderController.getRoomOrderByUserInRange(userId: userId, checkinDate: checkinDate, checkoutDate: checkoutDate)
        }
        isFirst = false
    }
    func changedCheckin() {
        checkin = formatDate(date: checkinDate)
        isOpenCheckin.toggle()
        isOpenCheckin = false
        if(checkinDate >= checkoutDate || checkout == ""){
            checkoutDate = checkinDate.addingTimeInterval(86401)
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
                Text("予約した部屋リスト")
                    .font(.title2)
                
                VStack {
                    Picker("Selection askdaksjd",selection: $selectedOption){
                        ForEach(0..<option.count) {
                            Text(self.option[$0])
                        }
                    }.onChange(of: selectedOption){ value in
                        if selectedOption == 0 {
                            listRooms = roomOrderController.getRoomOrderByUser(userId: userId)
                            if isOpenCheckin {
                                isOpenCheckin.toggle()
                            }
                            if isOpenCheckout {
                                isOpenCheckout.toggle()
                            }
                        }
                    }
                    
                    
                }
                if selectedOption == 1 {
                    HStack{
                        HStack{
                            Image(systemName: "calendar").foregroundColor(.gray)
                            TextField("チェックイン日", text: $checkin)
                                .disabled(true)
                            
                        }
                        .frame(width: 135, height: 35)
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
                            TextField("チェックアウト日", text: $checkout)
                                .disabled(true)
                            
                        }
                        .frame(width: 135, height: 35)
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
                }
                VStack(alignment: .leading){
                    if isFirst {
                        ListDataView(listRooms: roomOrderController.getRoomOrderByUser(userId: userId), roomViewModel: roomViewModel)
                    } else {
                        ListDataView(listRooms: listRooms, roomViewModel: roomViewModel)
                    }
                    
                }.padding(.bottom, 30)
                
                
            }
            if isOpenCheckin {
                ZStack{
                    Color(.black)
                        .opacity(0.3)
                        .onTapGesture {
                            isOpenCheckin.toggle()
                        }
                    
                    VStack(spacing: 15) {
                        DatePicker("",
                                   selection: $checkinDate,
                                   in: Date()...,
                                   displayedComponents: [.date]
                        )
                            .labelsHidden()
                            .datePickerStyle(.graphical)
                            .frame(maxWidth: .infinity)
                        
                        
                            .onChange(of: checkinDate) { value in
                                changedCheckin()
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
                    }
                    
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(25)
                    .padding(30)
                    
                }
            }
            if isOpenCheckout {
                ZStack{
                    Color(.black)
                        .opacity(0.3)
                        .onTapGesture {
                            isOpenCheckout.toggle()
                        }
                    VStack(spacing: 15) {
                        DatePicker("Checkout Date",
                                   selection: $checkoutDate,
                                   in: (checkinDate.addingTimeInterval(86400))...,
                                   displayedComponents: [.date]
                                   
                        )
                            .labelsHidden()
                            .datePickerStyle(.graphical)
                            .onChange(of: checkoutDate) { value in
                                changedCheckout()
                            }
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
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(25)
                    .padding(30)
                }
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
                            Text("チェックイン日: \(formatDate(date: orderRoom.checkinDate!))").frame(width: 120,alignment: .leading)
                            Text("チェックアウト日: \(formatDate(date: orderRoom.checkoutDate!))").frame(width: 120,alignment: .leading)
                        }
                        HStack {
                            Text("タイプ: \(room?.type ?? "")").frame(width: 120,alignment: .leading)
                            Text("開: \(room?.floor ?? "")").frame(width: 120,alignment: .leading)
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
            .padding(.horizontal,10)
            .padding(.vertical, 0)
        
    }
}

