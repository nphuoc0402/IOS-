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
    @State var listRooms:[RoomModel]
    
    // MARK: - View Body
    init(){
        listRooms = roomViewModel.filterRoom(checkinDate: Date(), checkoutDate: Date(), roomType: "全て")
    }
    var body: some View {
        ZStack{
            WrapMainView(list: $listRooms)
                .frame(alignment: .topLeading)
                .environmentObject(roomViewModel)
            Spacer()
        }.frame(alignment: .top)
        
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
    }
}

struct WrapMainView: View {
    let options = ["全て", "シングル", "ツイン"]
    @State var checkinDate = Date()
    @State var checkoutDate = Date().addingTimeInterval(86400)
    @State var selection = "All"
    @State var isOn = false
    @State var isShowAlert:Bool = false
    @State var total = 0
    @Binding var list: [RoomModel]
    @EnvironmentObject var roomViewModel : RoomViewModel
    @State private var selectedOptionIndex = 0
    init(list: Binding<[RoomModel]>){
        self._list = list
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
                                updateFilter()
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
                            .onChange(of: checkinDate) { value in
                                updateFilter()
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
                    })
                }
            }
            
            VStack{
                ListRoom(listRooms: $list)
                
            }
            .cornerRadius(5)
            .padding()
            
            VStack(alignment:.leading){
                Text("合計: ¥\(total)").frame(alignment: .leading).font(.headline)
            }.frame(maxWidth: .infinity,alignment: .leading).padding()
            
            Button(action: {doSave()}) {
                Text("予約")
                    .fontWeight(.semibold)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(40)
                
            }
            Spacer()
            
            
        }.alert(isPresented: $isShowAlert){
            
            Alert(
                title: Text(""),
                message: Text("この部屋を予約しますか?"),
                primaryButton: .destructive(Text("キャンセル"), action:{cancelSelectRoom()}),
                secondaryButton: .default(Text("OK"),action: {confirmSelectRoom()})
            )
            
        }
    }
    func updateFilter(){
        print(options[selectedOptionIndex])
        list = roomViewModel.filterRoom(checkinDate: checkinDate, checkoutDate: checkoutDate, roomType: options[selectedOptionIndex])
        
    }
    func showRoomInfo(){
        isShowAlert = true
    }
    func onTapCheckbox(){
        print("tap checkbox")
    }
    func confirmSelectRoom(){
        isShowAlert = true
        isOn = true
    }
    func cancelSelectRoom(){
        isOn = false
    }
    func doConfirm(){
        isShowAlert = true
        
    }
    func doSave(){
        //        print(checkinDate)
        //        print(checkoutDate)
        //        print(selection)
        //        roomViewModel.rooms.forEach{ item in
        //            print(item.name)
        //        }
    }
}
struct ExtractedView: View {
    @State private var isShowAlert: Bool = true
    @State var text1: String = "new"
    var body: some View {
        Text(text1)
    }
}

struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        // 1
        Button(action: {
            
            // 2
            configuration.isOn.toggle()
            
        }, label: {
            HStack {
                // 3
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                configuration.label
            }
        })
    }
}


