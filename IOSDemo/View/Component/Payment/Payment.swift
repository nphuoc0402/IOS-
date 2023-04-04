//
//  Payment.swift
//  IOSDemo
//
//  Created by tester on 2023/03/30.
//

import SwiftUI

struct Payment: View {
    let paymentMethod = ["後払い","前払い"]
    @State var deferredPayment = false
    @State private var selectedOptionIndex = 0
    @Binding var drafRoomOder: [RoomModel]
    @Binding var total: Int64
    @Binding var isPayment: Bool
    @Binding var checkinDate:Date
    @Binding var checkoutDate:Date
    var roomOrderController:RoomOrderController = RoomOrderController()
    init(drafRoomOder: Binding<[RoomModel]>, total: Binding<Int64>,isPayment: Binding<Bool>, checkinDate: Binding<Date>, checkoutDate: Binding<Date> ){
        self._drafRoomOder = drafRoomOder
        self._total = total
        self._isPayment = isPayment
        self._checkinDate = checkinDate
        self._checkoutDate = checkoutDate
    }
    var body: some View {
        
        VStack{
            Text("支払い")
                .font(.system(size:20))
                .frame(alignment: .top)
            VStack(alignment: .leading){
                List(drafRoomOder){room in
                    HStack{
                        VStack{
                            room.image
                                .resizable()
                                .frame(width: 60, height:60)
                        }
                        VStack(spacing: 5){
                            Text("部屋:   \(room.name)")
                            Text("     価格: ¥\(room.price)")
                            Text("  タイプ: \(room.type)")
                        }
                        .font(.system(size: 12))
                    }.padding(0)
                }.cornerRadius(5)
                    .padding(.horizontal,20)
            }.frame( height: 300)
            
            VStack(alignment:.leading){
                Text("合計: ¥\(total)").frame(alignment: .leading).font(.headline)
            }.frame(maxWidth: .infinity,alignment: .leading).padding(.horizontal,20)
            
            VStack(alignment: .leading ,spacing: 10){
                HStack{
                    Text("支払方法")
                    ForEach(0..<paymentMethod.count) { index in
                        Button(action: {
                            selectedOptionIndex = index
                        }, label: {
                            HStack {
                                Text(paymentMethod[index])
                                Image(systemName: selectedOptionIndex == index ? "largecircle.fill.circle" : "circle")
                            }
                            .padding(20)
                        }).onChange(of: selectedOptionIndex) { option in
                            if(option == 1){
                                deferredPayment = true
                            }else {
                                deferredPayment = false
                            }
                        }
                    }}
                
            }
            HStack{
                if deferredPayment{
                    TypePayment()
                }
                
            }.frame(height: 180)
            
            HStack(alignment: .center, spacing: 30){
                Button {
                    isPayment = false
                } label: {
                    Text("戻る")
                        .font(.system(size:16))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .frame(height: 30)
                    
                }
                Button {
                    saveOrder()
                } label: {
                    Text("予約を確認する")
                        .font(.system(size:16))
                        .foregroundColor(.white)
                        .padding(.horizontal,20)
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .frame(height: 30)

                }
                
            }
            .padding(10)
            .frame(alignment: .bottomLeading)
        }
        
        
        
        
    }
    func saveOrder(){
        print(checkoutDate)
        print(checkinDate)
        for draf in drafRoomOder {
            roomOrderController.addRoomOrder(userId: "1", roomId: draf.id, checkinDate: checkinDate, checkoutDate: checkoutDate, payment: isPayment)
        }
    }
}


//struct Payment_Previews: PreviewProvider {
//    static var previews: some View {
////        Payment()
//    }
//}
