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
      // MARK: - View Body
      
      var body: some View {
          ZStack{
              WrapMainView().frame(alignment: .topLeading)
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
    @State var checkinDate = Date()
    @State var checkoutDate = Date().addingTimeInterval(86400)
    @State var roomType = "Single"
    @State var isOn = false
    @State var isShowAlert:Bool = false
    @State var total = 0;
    @EnvironmentObject var roomViewModel : RoomViewModel
    
    var body: some View {
        
        VStack{
            Text("Booking Room").font(.largeTitle)
            HStack{
                
                DatePicker("",
                           selection: $checkinDate,
                           in: Date()...,
                           displayedComponents: [.date]
                ).padding()
                    .frame(alignment: .leading)
                Text("-")
                DatePicker("",
                           selection: $checkoutDate,
                           in: checkoutDate...,
                           displayedComponents: [.date]
                ).padding(.horizontal)
                    .frame(alignment: .trailing)
            }.frame(alignment: .leading)
//            .onChange(of: <#T##Equatable#>, perform: <#T##(Equatable) -> Void##(Equatable) -> Void##(_ newValue: Equatable) -> Void#>)
                
                RadioButtonGroup(items: ["Single", "Double", "All"], selectedId: roomType){ selected in
                    roomType = selected}.padding()
                ScrollView(.vertical, showsIndicators: true) {
                    VStack{
                        ForEach(roomViewModel.rooms){ room in
                            HStack{
                                Button(action:{showRoomInfo()}){
                                    Text("Room \(room.name)")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                        .font(.largeTitle)
                                }
                                
                                Button(action:{doConfirm()}){
                                    Toggle("",isOn: $isOn).toggleStyle(iOSCheckboxToggleStyle()).font(.largeTitle)
                                }
                            }.padding(8)
                            
                        }
                    }.frame(alignment: .leading)
                }
                .cornerRadius(5)
                .background(Color.gray)
                .frame(maxHeight: 200,alignment: .trailing)
                .padding()
                
            VStack(alignment:.leading){
                    Text("Total: \(total)¥").frame(alignment: .leading).font(.headline)
            }.frame(maxWidth: .infinity,alignment: .leading).padding()
                
                Button(action: {doSave()}) {
                    Text("Save")
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .border(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                        .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                        .frame(width: 150, height: 50)
                }
                Spacer()
                
                
        }.alert(isPresented: $isShowAlert){
            
            Alert(
                    title: Text(""),
                    message: Text("Do you want to order this Room?"),
                    primaryButton: .destructive(Text("Cancel"), action:{cancelSelectRoom()}),
                    secondaryButton: .default(Text("OK"),action: {confirmSelectRoom()})
            )
            
        }
            
        
        
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
        print(checkinDate)
        print(checkoutDate)
        print(roomType)
        roomViewModel.rooms.forEach{ item in
            print(item.name)
        }
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

