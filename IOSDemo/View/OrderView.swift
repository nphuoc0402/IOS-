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
    @State var days = 1
    // MARK: - View Body
//    init(){
//        listRooms = roomViewModel.filterRoom(checkinDate: Date(), checkoutDate: Date(), roomType: "全て")
//    }
    var body: some View {
        ZStack{
            if isPayment {
                 Payment(drafRoomOder: $drafRoomOrder, total: $total,isPayment: $isPayment)
            }else {
                WrapMainView(list: $listRooms, total: $total, drafRoomOrder: $drafRoomOrder,isPayment: $isPayment, checkinDate:$checkinDate, checkoutDate:$checkoutDate, selectedOptionIndex: $selectedOptionIndex,days: $days)
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
    let options = ["全て", "シングル", "ツイン"]
    
    @State var showAlert = false
    
    
    @EnvironmentObject var roomViewModel : RoomViewModel
    
    
    init(list: Binding<[RoomModel]>,total: Binding<Int64>, drafRoomOrder: Binding<[RoomModel]>, isPayment: Binding<Bool>, checkinDate: Binding<Date>,checkoutDate: Binding<Date>, selectedOptionIndex: Binding<Int>, days: Binding<Int>){
        self._list = list
        self._total = total
        self._drafRoomOrder = drafRoomOrder
        self._isPayment = isPayment
        self._checkinDate = checkinDate
        self._checkoutDate = checkoutDate
        self._selectedOptionIndex = selectedOptionIndex
        self._days = days
    }
    
    var body: some View {
        VStack{
            ZStack{
                Image("Beach 1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                VStack(){
                    Text("予約室").font(.largeTitle)
                    HStack{
                        DatePicker("",
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
                
                ListRoom(listRooms: $list, drafRoomOrder: $drafRoomOrder, total: $total, days: $days)
                
            }
            .cornerRadius(5)
            .padding()
            
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
            Alert(title: Text("This field is required"),
            message: Text("Please enter valid account"))
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
//    func confirmSelectRoom(){
//        //        isShowAlert = true
//        isOn = true
//    }
//    func cancelSelectRoom(){
//        isOn = false
//    }
    func doConfirm(){
        //        isShowAlert = true
        
    }
    func doSave(){
        if(!$drafRoomOrder.isEmpty){
            isPayment = true
        }else {
            showAlert = true
        }
        
    
        //        print(checkinDate)
        //        print(checkoutDate)
        //        print(selection)
        //        roomViewModel.rooms.forEach{ item in
        //            print(item.name)
        //        }
    }
}



