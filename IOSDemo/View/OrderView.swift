//
//  OrderView.swift
//  RoomOrder
//
//  Created by EP_NonFunc on 2023/03/17.
//

import SwiftUI

struct OrderView: View {
    @EnvironmentObject var opDat:OpDat
    @State private var showMenu: Bool = false
    var roomViewModel : RoomViewModel = RoomViewModel()
    @State var listRooms:[RoomModel] = []
    @State var total: Int64 = 0
    @State var isPayment:Bool = false
    @State var drafRoomOrder:[RoomModel] = []
    @State var checkinDate = Date()
    @State var checkoutDate = Date().addingTimeInterval(86400)
    @State private var selectedOptionIndex = 0
    @State var isShowDetail = false
    @State var days = 1
    @State var checkin:String = ""
    @State var checkout:String = ""
    @State var isSearched = false
    var body: some View {
        ZStack{
            if isPayment {
                Payment(drafRoomOder: $drafRoomOrder, total: $total,isPayment: $isPayment, checkinDate: $checkinDate, checkoutDate: $checkoutDate, listRooms: $listRooms)
            }else {
                WrapMainView(list: $listRooms, total: $total, drafRoomOrder: $drafRoomOrder,isPayment: $isPayment, checkinDate:$checkinDate, checkoutDate:$checkoutDate, selectedOptionIndex: $selectedOptionIndex,days: $days, isShowDetail: $isShowDetail, checkin: $checkin, checkout: $checkout,isSearched: $isSearched)
                    .frame(alignment: .topLeading)
                    .environmentObject(roomViewModel)
            }
            Spacer()
        }.frame(alignment: .top)
    }
}
struct WrapMainView: View {
    @Binding var list: [RoomModel]
    @Binding var total: Int64
    @Binding var drafRoomOrder:[RoomModel]
    @Binding var isPayment: Bool
    @Binding var checkinDate:Date
    @Binding var checkoutDate:Date
    @Binding var selectedOptionIndex: Int
    @Binding var days:Int
    @Binding var isShowDetail: Bool
    @Binding var checkin: String
    @Binding var checkout: String
    @Binding var isSearched:Bool
    let options = ["全て", "シングル", "ツイン"]
    @State var showAlert = false
    @State var detailRoomId:String = ""
    @EnvironmentObject var roomViewModel : RoomViewModel
    @State var isOpenCheckin = false
    @State var isOpenCheckout = false
    
    init(list: Binding<[RoomModel]>,total: Binding<Int64>, drafRoomOrder: Binding<[RoomModel]>, isPayment: Binding<Bool>, checkinDate: Binding<Date>,checkoutDate: Binding<Date>, selectedOptionIndex: Binding<Int>, days: Binding<Int>, isShowDetail: Binding<Bool>, checkin: Binding<String>, checkout: Binding<String>, isSearched: Binding<Bool>){
        self._list = list
        self._total = total
        self._drafRoomOrder = drafRoomOrder
        self._isPayment = isPayment
        self._checkinDate = checkinDate
        self._checkoutDate = checkoutDate
        self._selectedOptionIndex = selectedOptionIndex
        self._days = days
        self._isShowDetail = isShowDetail
        self._checkin = checkin
        self._checkout = checkout
        self._isSearched = isSearched
    }
    
    var body: some View {
        ZStack {
            VStack{
                ZStack{
                    VStack(){
                        Text("予約室").font(.title2).padding(.vertical, 20)
                        HStack{
                            
                            HStack{
                                Image(systemName: "calendar").foregroundColor(.gray)
                                TextField("チェックイン日", text: $checkin)
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
                                TextField("チェックアウト日", text: $checkout)
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
                        }
                    }
                    
                }
                
                HStack {
                    ForEach(0..<options.count) { index in
                        Button(action: {
                            selectedOptionIndex = index
                        }, label: {
                            HStack {
                                Text(options[index])
                                Image(systemName: selectedOptionIndex == index ? "largecircle.fill.circle" : "circle")
                            }
                            .padding(20)
                        }).onChange(of: selectedOptionIndex) { value in
                            updateFilter()
                        }
                    }
                }
                
                VStack{
                    VStack(spacing: 0) {
                        List(list){ room in
                            Button(action: {
                                isShowDetail = true
                                detailRoomId = room.id
                            }) {
                                RoomRow(
                                    isChecked: self.drafRoomOrder.contains(where: {$0.id == room.id}),
                                    room: room,
                                    action: {
                                        if self.drafRoomOrder.contains(where: {$0.id == room.id}) {
                                            self.drafRoomOrder.removeAll(where: { $0.id == room.id })
                                            
                                            total = total - room.price * Int64(days)
                                        } else {
                                            self.drafRoomOrder.append(room)
                                            total += room.price * Int64(days)
                                            
                                        }
                                    }
                                )
                            }
                        }
                    }
                }
                .cornerRadius(5)
                .padding([.leading, .trailing])
                VStack(alignment:.leading){
                    Text("合計: ¥\(total)").frame(alignment: .leading).font(.headline)
                }.frame(maxWidth: .infinity,alignment: .leading).padding()
                Button(action: {doSave()}) {
                    Text("予約画面へ")
                        .font(.system(size:16))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .frame(height: 30)
                }
                Spacer()
            }.alert(isPresented: $showAlert){
                Alert(title: Text("この項目は必須です"),
                      message: Text("項目を選択してください"))
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
            if isShowDetail {
                let room:RoomModel? = roomViewModel.getRoomById(id: detailRoomId)
                RoomDetail(isShowDetail: $isShowDetail, roomDetail: room){
                }
            }
        }
    }
    
    func updateFilter(){
        if checkin != "" && checkout != "" && isSearched {
            list = roomViewModel.filterRoom(checkinDate: checkinDate, checkoutDate: checkoutDate, roomType: options[selectedOptionIndex])
        }
    }
    func filterData() {
        if checkin != "" && checkout != "" {
            list = roomViewModel.filterRoom(checkinDate: checkinDate, checkoutDate: checkoutDate, roomType: options[selectedOptionIndex])
            days = numberOfDaysBetween(start: formatDateHelper(date: checkinDate), end: formatDateHelper(date: checkoutDate))
            total = 0
            drafRoomOrder.removeAll()
            isSearched = true
        }
    }
    func doSave(){
        if(!$drafRoomOrder.isEmpty){
            isPayment = true
        } else {
            showAlert = true
        }
    }
    
    func changedCheckin() {
        checkin = formatDate(date: checkinDate)
        isOpenCheckin.toggle()
        isOpenCheckin = false
        if(formatDateHelper(date: checkinDate) >= formatDateHelper(date: checkoutDate) || checkout == "") {
            checkoutDate = checkinDate.addingTimeInterval(86400)
            checkout = formatDate(date: checkoutDate)
        }
    }
    
    func changedCheckout() {
        isOpenCheckout.toggle()
        isOpenCheckout = false
        checkout = formatDate(date: checkoutDate)
    }
    
    func onExpandCheckin() {
        isOpenCheckin.toggle()
    }
    
    func onExpandCheckout() {
        isOpenCheckout.toggle()
    }
}



