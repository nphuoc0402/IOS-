//
//  Payment.swift
//  IOSDemo
//
//  Created by tester on 2023/03/30.
//

import SwiftUI
import UIKit

struct Payment: View {
    @ObservedObject var card = Card()
    @AppStorage("userId") var userId:String = ""
    let paymentMethod = ["後払い","前払い"]
    var title = "本気ですか？"
    var message = "本当に部屋を予約しますか"
    var buttontitle = "予約します"
    @State var isShowingAlert = false
    @State var isActive = false
    @State var deferredPayment = false
    @State private var selectedOptionIndex = 0
    @Binding var drafRoomOder: [RoomModel]
    @Binding var total: Int64
    @Binding var isPayment: Bool
    @Binding var checkinDate:Date
    @Binding var checkoutDate:Date
    @Binding var listRooms:[RoomModel]
    @State var isMessACName: Bool = false
    @State var isMessACNumber: Bool = false
    @State var isWrongAccount: Bool = false
    @State var isMessExpiredDate: Bool = false
    @State var isMessSecureCode: Bool = false
    var roomOrderController:RoomOrderController = RoomOrderController()
    init(drafRoomOder: Binding<[RoomModel]>, total: Binding<Int64>,isPayment: Binding<Bool>, checkinDate: Binding<Date>, checkoutDate: Binding<Date>,listRooms: Binding<[RoomModel]> ){
        self._drafRoomOder = drafRoomOder
        self._total = total
        self._isPayment = isPayment
        self._checkinDate = checkinDate
        self._checkoutDate = checkoutDate
        self._listRooms = listRooms
    }
    var body: some View {
        VStack(spacing: 5){
            Text("支払い")
                .font(.title2)
                .frame(alignment: .center)
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
            HStack{
                Text("支払方法")
                Spacer(minLength: 0)
                ForEach(0..<paymentMethod.count) { index in
                    Button(action: {
                        selectedOptionIndex = index
                    }, label: {
                        HStack {
                            Text(paymentMethod[index])
                            Image(systemName: selectedOptionIndex == index ? "largecircle.fill.circle" : "circle")
                        }
                        .padding(10)
                    }).onChange(of: selectedOptionIndex) { option in
                        if(option == 1){
                            deferredPayment = true
                            isMessACName = false
                            isMessACNumber = false
                            isMessSecureCode = false
                            isMessExpiredDate = false
                        }else {
                            deferredPayment = false
                        }
                    }
                }
                Spacer(minLength: 5)
            }
            .padding(.horizontal, 20)
            Spacer(minLength: 10)
            HStack{
                if deferredPayment {
                    CardView()
                    
                }
                
            }
            .frame(height:220)
            Spacer(minLength: 10)
            HStack(alignment: .bottom){
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
                    payment()
                    
                } label: {
                    Text("予約を確認する")
                        .font(.system(size:16))
                        .foregroundColor(.white)
                        .padding(.horizontal,20)
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .frame(height: 30)
                    
                }.alert(isPresented: $isShowingAlert){
                    Alert(title: Text("本気ですか？"),
                          message: Text("本当に部屋を予約しますか"),
                          primaryButton: .default(Text("Ok")){
                        saveOrder()
                    },
                          secondaryButton: .cancel(Text("キャンセル")))
                }
                
            }
            .padding(10)
            .frame(alignment: .bottomLeading)
        }
        if isActive {
            Color.black.opacity(0.5).ignoresSafeArea(.all)
            DialogView(isShowDetail: $isActive,image: Image("success"), title: "成功", message: "予約が成功したことを確認する", buttonTitle: "OK") {
                isActive = false
                isPayment = false
                drafRoomOder.removeAll()
                total = 0
            }
        }
        
        if isWrongAccount {
            Color.black.opacity(0.5).ignoresSafeArea(.all)
            DialogView(isShowDetail: $isWrongAccount, image: Image("failure"), title: "失敗", message: "無効なアカウントです。再入力してください", buttonTitle: "OK") {
                isWrongAccount = false
            }
        }
        
    }
    
    @ViewBuilder
    func CardView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack{
                Image("mastercard")
                    .resizable()
                    .frame(width: 30, height:30)
                Image("visa")
                    .resizable()
                    .frame(width: 30, height:30)
                Image("amex")
                    .resizable()
                    .frame(width: 30, height:30)
                Image("discover").resizable()
                    .frame(width: 30, height:30)
                Image("jcb").resizable()
                    .frame(width: 30, height:30)
                Image("unionpay").resizable()
                    .frame(width: 30, height:30)
                Image("paypal").resizable()
                    .frame(width: 30, height:30)
                
            }
            .padding(.horizontal, 20)
            VStack(spacing: 0){
                TextField("名様を入力してください", text: $card.name)
                    .padding(10)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .fixedSize(horizontal: false, vertical: true)
                
                
            }
            .padding(.horizontal)
            if isMessACName {
                if card.namePromt != "" {
                    Text(card.namePromt)
                        .frame(alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
            }
            VStack(spacing: 0){
                HStack{
                    Image(systemName: "creditcard").foregroundColor(.gray)
                    TextField("XXXX XXXX XXXX XXXX", text: .init(get: {
                        card.cardNumber
                    }, set: { value in
                        card.cardNumber = ""
                        let startIndex = value.startIndex
                        for index in 0..<value.count {
                            let stringIndex = value.index(startIndex, offsetBy: index)
                            card.cardNumber += String(value[stringIndex])
                            
                            if (index + 1) % 5 == 0 && value[stringIndex] != " " {
                                card.cardNumber.insert(" ", at: stringIndex)
                            }
                        }
                        
                        if card.cardNumber.last == " " {
                            card.cardNumber.removeLast()
                        }
                        
                        card.cardNumber = String(card.cardNumber.prefix(19))
                    })).keyboardType(.numberPad)
                }
                .padding(10)
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
                .fixedSize(horizontal: false, vertical: true)
                
            }.padding(.horizontal)
            
            if isMessACNumber {
                if card.cardNumberPromt != "" {
                    Text(card.cardNumberPromt)
                        .frame(alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
            }
            VStack{
                HStack{
                    TextField("MM/YY(月/年)", text: .init(get: {
                        card.expiredDate
                    },set : { value in
                        card.expiredDate = ""
                        let startIndex = value.startIndex
                        for index in 0..<value.count {
                            let stringIndex = value.index(startIndex, offsetBy: index)
                            card.expiredDate += String(value[stringIndex])
                            
                            if (index + 1) % 3 == 0 && value[stringIndex] != "/" {
                                card.expiredDate.insert("/", at: stringIndex)
                            }
                        }
                        
                        if value.last == "/" {
                            card.expiredDate.removeLast()
                        }
                        
                        card.expiredDate = String(card.expiredDate.prefix(5))
                    }))
                    .padding(10)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10);
                    HStack{
                        Image(systemName: "creditcard")
                        TextField("セキュリティコード", text: .init(get: {
                            card.secureCode
                        }, set: { value in
                            card.secureCode = value
                            
                            card.secureCode = String(card.secureCode.prefix(3))
                        }))
                        .keyboardType(.numberPad)
                        
                    }
                    .padding(10)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                }
                HStack {
                    if isMessExpiredDate {
                        if card.expiredDatePromt != "" {
                            Text(card.expiredDatePromt)
                                .frame(alignment: .leading)
                                .fixedSize(horizontal: false, vertical: false)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                                .frame(width: 175, height: 30, alignment: .topLeading)
                            
                        }else {
                            Spacer()
                        }
                    }
                    
                    Spacer(minLength: 2)
                    if isMessSecureCode {
                        if card.secureCodePromt != "" {
                            Text(card.secureCodePromt)
                                .frame(alignment: .leading)
                                .fixedSize(horizontal: false, vertical: true)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                                .frame(width: 175, height: 30, alignment: .topLeading)
                        }else {
                            Spacer()
                        }
                    
                    }
                }
            }.padding(.horizontal)
            
        }
    }
    
    func payment(){
        if !deferredPayment {
            isShowingAlert = true
        } else if (card.isCardNumberValid() && card.isNameValid() && card.isExpiredDateValid() && card.isSecureCodeValid()) {
            
            for cardCustomer in cards {
                if (cardCustomer.name == card.name && cardCustomer.card_number == card.cardNumber.replacingOccurrences(of: " ", with: "") && cardCustomer.expired_date == card.expiredDate && cardCustomer.secure_code == card.secureCode){
                    isShowingAlert = true
                    return
                }
            }
            isWrongAccount = true
        } else {
            if !card.isNameValid(){
                isMessACName = true
            }
            if !card.isCardNumberValid() {
                isMessACNumber = true
            }
            if !card.isExpiredDateValid() {
                isMessExpiredDate = true
            }
            if !card.isSecureCodeValid() {
                isMessSecureCode = true
            }
        }
        
    }
    
    
    func saveOrder(){
        for draf in drafRoomOder {
            roomOrderController.addRoomOrder(userId: userId, roomId: draf.id, checkinDate: checkinDate, checkoutDate: checkoutDate, payment: isPayment)
            listRooms.removeAll(where: { $0.id == draf.id})
        }
        isActive = true
        
    }
}




//struct Payment_Previews: PreviewProvider {
//    static var previews: some View {
////        Payment()
//    }
//}
