//
//  Payment.swift
//  IOSDemo
//
//  Created by tester on 2023/03/30.
//

import SwiftUI

struct Payment: View {
    let paymentMethod = ["前払い","後払い"]
    @State private var selectedOptionIndex = 0
    @Binding var drafRoomOder: [RoomModel]
    @Binding var total: Int64
    @Binding var isPayment: Bool
    init(drafRoomOder: Binding<[RoomModel]>, total: Binding<Int64>,isPayment: Binding<Bool> ){
        self._drafRoomOder = drafRoomOder
        self._total = total
        self._isPayment = isPayment
    }
    var body: some View {
        
        VStack{
            VStack{
                Text("支払い")
                
            }
            
            VStack{
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
                    }
                }.cornerRadius(5)
                    .padding()
            }
            
            VStack(alignment:.leading){
                Text("合計: ¥\(total)").frame(alignment: .leading).font(.headline)
            }.frame(maxWidth: .infinity,alignment: .leading).padding()
            
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
                    })
                }
            }
            HStack(alignment: .center, spacing: 30){
                Button {
                    isPayment = false
                } label: {
                    Text("戻る")
                        .font(.system(size:16))
                        .foregroundColor(.white)
                        .padding(.horizontal, 50)
                        .padding(.vertical)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .frame(height: 30)
                    
                }
                Button {
                    
                } label: {
                    Text("予約を確認する")
                        .font(.system(size:16))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .frame(height: 30)

                }
                
            }
            .padding()
        }
        
        
        
        
    }
}


//struct Payment_Previews: PreviewProvider {
//    static var previews: some View {
////        Payment()
//    }
//}
