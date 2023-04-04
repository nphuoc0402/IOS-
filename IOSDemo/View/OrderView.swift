//
//  OrderView.swift
//  RoomOrder
//
//  Created by EP_NonFunc on 2023/03/17.
//

import SwiftUI

struct OrderView: View {
    @State private var showMenu: Bool = false
    @State private var text1: String = "My text"
    @State private var text2: String = "My text"
    
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
    // MARK: - View Body
    //    init(){
    //        listRooms = roomViewModel.filterRoom(checkinDate: Date(), checkoutDate: Date(), roomType: "全て")
    //    }
    var body: some View {
        ZStack{
            if isPayment {
                Payment(drafRoomOder: $drafRoomOrder, total: $total,isPayment: $isPayment, checkinDate: $checkinDate, checkoutDate: $checkoutDate)
            }else {
                WrapMainView(list: $listRooms, total: $total, drafRoomOrder: $drafRoomOrder,isPayment: $isPayment, checkinDate:$checkinDate, checkoutDate:$checkoutDate, selectedOptionIndex: $selectedOptionIndex,days: $days, isShowDetail: $isShowDetail)
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
    let options = ["全て", "シングル", "ツイン"]
    
    @State var showAlert = false
    @State var detailRoomId:String = ""
    
    @EnvironmentObject var roomViewModel : RoomViewModel
    @State var isOpenCheckin = false
    @State var isOpenCheckout = false
    @State private var checkin:String = ""
    @State private var checkout:String = ""
    
    init(list: Binding<[RoomModel]>,total: Binding<Int64>, drafRoomOrder: Binding<[RoomModel]>, isPayment: Binding<Bool>, checkinDate: Binding<Date>,checkoutDate: Binding<Date>, selectedOptionIndex: Binding<Int>, days: Binding<Int>, isShowDetail: Binding<Bool>){
        self._list = list
        self._total = total
        self._drafRoomOrder = drafRoomOrder
        self._isPayment = isPayment
        self._checkinDate = checkinDate
        self._checkoutDate = checkoutDate
        self._selectedOptionIndex = selectedOptionIndex
        self._days = days
        self._isShowDetail = isShowDetail
    }
    
    var body: some View {
        ZStack {
            
            VStack{
                ZStack{
                    VStack(){
                        Text("予約室").font(.largeTitle)
                        HStack{
                            
                            TextField("Checkin Date", text: $checkin)
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
                            TextField("Checkout Date", text: $checkout)
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
                    ListRoom(listRooms: $list, drafRoomOrder: $drafRoomOrder, total: $total, days: $days, isShowDetail: $isShowDetail, detailRoomId: $detailRoomId)
                }
                .cornerRadius(5)
                .padding()
                .frame(width: .infinity, height: 420, alignment: .center)
                
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
            
            if isShowDetail {
                Color.black.opacity(0.5).ignoresSafeArea(.all)
                    .onTapGesture {
                        isShowDetail = false
                    }
                    .allowsTightening(true)
                let room:RoomModel? = roomViewModel.getRoomById(id: detailRoomId)
                RoomDetail(isShowDetail: $isShowDetail, roomDetail: room) {
                    print(detailRoomId)
                }
            }
            VStack {
                if isOpenCheckin {
                    DatePicker("Checkin Date",
                               selection: $checkinDate,
                               in: Date()...,
                               displayedComponents: [.date]
                    )
                        .labelsHidden()
                        .datePickerStyle(.graphical)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(40)
                        .border(.gray,width:2)
                        .onChange(of: checkinDate) { value in
                            changedCheckin()
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
                        .cornerRadius(40)
                        .border(.gray,width:2)
                    
                        .onChange(of: checkoutDate) { value in
                            changedCheckout()
                        }
                }
            }.background(Color.white)
                .cornerRadius(5)
                .padding()
        }
        
    }
    
    
    
    
    func updateFilter(){
        list = roomViewModel.filterRoom(checkinDate: checkinDate, checkoutDate: checkoutDate, roomType: options[selectedOptionIndex])
        
    }
    func filterData() {
        list = roomViewModel.filterRoom(checkinDate: checkinDate, checkoutDate: checkoutDate, roomType: options[selectedOptionIndex])
        days = numberOfDaysBetween(start: formatDateHelper(date: checkinDate), end: formatDateHelper(date: checkoutDate))
        total = 0
        drafRoomOrder.removeAll()
    }
    func showRoomInfo(){
        //        isShowAlert = true
    }
    func onTapCheckbox(){
        print("tap checkbox")
    }
    
    func doConfirm(){
        //        isShowAlert = true
        
    }
    func doSave(){
        if(!$drafRoomOrder.isEmpty){
            isPayment = true
        }else {
            showAlert = true
        }
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



