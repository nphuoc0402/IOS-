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
    @State var checkoutDate = Date().addingTimeInterval(86400)
    @State var isOpenCheckin = false
    @State var isOpenCheckout = false
    @State private var checkin:String = ""
    @State private var checkout:String = ""
    @State var isPickCheckin: Bool = false
    @State var isPickCheckout: Bool = false
    @State var isFirst: Bool = true
    @State var selectedOption:Int = 0
    let option = ["全て表示","特定期間を表示"]
    
    func filterData() {
        if isPickCheckin && isPickCheckout {
            isFirst = false
            listRooms = roomOrderController.getRoomOrderByUserInRange(userId: userId, checkinDate: checkinDate, checkoutDate: checkoutDate)
        }
    }
    func changedCheckin() {
        checkin = formatDate(date: checkinDate)
        if(formatDateHelper(date: checkinDate) >= formatDateHelper(date: checkoutDate) || checkout == ""){
            checkoutDate = checkinDate.addingTimeInterval(86400)
            checkout = formatDate(date: checkoutDate)
        }
    }
    func changedCheckout() {
        checkout = formatDate(date: checkoutDate)
    }
    
    var body: some View {
        ZStack{
            VStack{
                Text("予約した部屋リスト")
                    .font(.title2)
                    .padding(.vertical,20)
                    .accessibilityIdentifier("lblHeader")
                
                VStack {
                    Text("検索タイプ").font(.subheadline).padding(0)
                    HStack(alignment: .center, spacing: 5){
                        ForEach(0..<option.count) { index in
                            Button(action: {
                                selectedOption = index
                            }, label: {
                                HStack {
                                    Text(option[index])
                                    Image(systemName: selectedOption == index ? "largecircle.fill.circle" : "circle")
                                }
                                .padding(5)
                            }).onChange(of: selectedOption) { value in
                                if selectedOption == 0 {
                                    listRooms = roomOrderController.getRoomOrderByUser(userId: userId)
                                    if isOpenCheckin {
                                        isOpenCheckin.toggle()
                                    }
                                    if isOpenCheckout {
                                        isOpenCheckout.toggle()
                                    }
                                }else {
                                    if isFirst {
                                        listRooms.removeAll()
                                    }else {
                                        filterData()
                                    }
                                }
                            }.accessibilityIdentifier(option[index])
                        }
                        
                    }
                    
                }
                if selectedOption == 1 {
                    HStack{
                        HStack{
                            Image(systemName: "calendar").foregroundColor(.gray)
                            TextField("チェックイン日", text: $checkin)
                                .disabled(true)
                                .accessibilityIdentifier("txtCheckin")
                        }
                        .frame(width: 135, height: 35)
                        .padding([.leading], 5)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .onTapGesture {
                            isOpenCheckin.toggle()
                            isPickCheckin = true
                            isPickCheckout = true
                            checkin = formatDate(date: checkinDate)
                        }
                        Image(systemName: "arrow.right")
                            .foregroundColor(.black)
                        
                        HStack{
                            Image(systemName: "calendar").foregroundColor(.gray)
                            TextField("チェックアウト日", text: $checkout)
                                .disabled(true)
                                .accessibilityIdentifier("txtCheckout")
                        }
                        .frame(width: 135, height: 35)
                        .padding([.leading], 5)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .onTapGesture {
                            isOpenCheckout.toggle()
                            isPickCheckout = true
                            checkout = formatDate(date: checkoutDate)
                        }
                        Image(systemName: "magnifyingglass").font(.title).onTapGesture {
                            filterData()
                        }
                        .accessibilityIdentifier("btnSearch")
                        
                    }.padding()
                }
                VStack(alignment: .leading){
                    if selectedOption == 0 {
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
                                   displayedComponents: [.date]
                        )
                            .labelsHidden()
                            .datePickerStyle(.graphical)
                            .frame(maxWidth: .infinity)
                            .onChange(of: checkinDate) { value in
                                changedCheckin()
                            }
                            .accessibilityIdentifier("datePicker")
                        Button(action: {
                            isOpenCheckin.toggle()
                        }){
                            Text("閉じる")
                                .font(.system(size:16))
                                .foregroundColor(.white)
                                .padding(.horizontal,20)
                                .padding(10)
                                .background(Color.blue)
                                .cornerRadius(20)
                        }.accessibilityIdentifier("btnCloseDatePicker")
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(25)
                    .padding(30)
                    
                }.ignoresSafeArea()
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
                            .accessibilityIdentifier("datePicker")
                        Button(action: {
                            isOpenCheckout.toggle()
                        }) {
                            Text("閉じる")
                                .font(.system(size:16))
                                .foregroundColor(.white)
                                .padding(.horizontal,20)
                                .padding(10)
                                .background(Color.blue)
                                .cornerRadius(20)
                        }.accessibilityIdentifier("btnCloseDatePicker")
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(25)
                    .padding(30)
                }.ignoresSafeArea()
            }
            Spacer()
        }.frame(alignment: .top)
    }
}

struct ListDataView: View {
    var listRooms: [RoomOrder]
    var roomViewModel: RoomViewModel
    var body: some View {
        List {
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
                            Text("予約日: \(formatDate(date: orderRoom.orderDate!))").frame(width: 120,alignment: .leading)
                        }
                        HStack {
                            Text("合計: ¥\(total)").frame(width: 120,alignment: .leading)
                            if orderRoom.payment {
                                Text("支払方法: 元払い").frame(width: 120,alignment: .leading)
                            }else {
                                Text("支払方法: 後払い").frame(width: 120,alignment: .leading)
                            }
                            
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

