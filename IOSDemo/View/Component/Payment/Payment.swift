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
    let paymentMethod = ["後払い","事前決済"]
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
    @Namespace var bottomID
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView{
            VStack(spacing: 5){
                ZStack{
                    GeometryReader { _ in
                            HStack {
                                ItemMenuView()
                            }
                        
                    }
                    Text("支払い")
                        .font(.title2)
                        .frame(alignment: .center)
                        .padding(.vertical,20)
                        .accessibilityIdentifier("lblHeader")
                }
               
                VStack(alignment: .leading){
                    List(drafRoomOder){room in
                        HStack{
                            VStack{
                                room.image
                                    .resizable()
                                    .frame(width: 60, height:60)
                            }
                            VStack(spacing: 5){
                                Text("部屋: \(room.name)")
                                Text("価格: ¥\(room.price)")
                                Text("タイプ: \(room.type)")
                            }
                            .font(.system(size: 12))
                        }.padding(0)
                    }.cornerRadius(5)
                        .padding(.horizontal,20)
                }.frame( height: 300)
                    
                VStack(alignment:.leading){
                    Text("合計: ¥\(total)").frame(alignment: .leading).font(.headline).accessibilityIdentifier("total")
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
                        }.accessibilityIdentifier("opt\(index)")
                    }
                    Spacer(minLength: 5)
                }
                .padding(.horizontal, 20)
                
                if deferredPayment {
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
                            TextField("カード名様人氏名を入力してください", text: $card.name)
                                .padding(10)
                                .background(Color.black.opacity(0.05))
                                .cornerRadius(10)
                                .fixedSize(horizontal: false, vertical: true)
                                .accessibilityIdentifier("txtNameCard")
                                .onTapGesture {
                                    withAnimation {
                                        proxy.scrollTo(bottomID, anchor: .bottom)
                                    }
                                }
                            
                            
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
                                    .accessibilityIdentifier("errMsgACName")
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
                                    .accessibilityIdentifier("txtCardNumber")
                                    .onTapGesture {
                                        withAnimation {
                                            proxy.scrollTo(bottomID, anchor: .bottom)
                                        }
                                    }
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
                                    .accessibilityIdentifier("errMsgACNumber")
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
                                        if let myInt1 = Int(String(value[startIndex])) {
                                            if(index == 0 && myInt1 > 1){
                                                card.expiredDate.insert("0", at: stringIndex)
                                            }
                                        }
                                        
                                        if let myInt2 = Int(String(value[stringIndex])) {
                                            if(index == 1 && myInt2 > 2 && value[value.index(startIndex, offsetBy: 0)] == "1"){
                                                card.expiredDate.insert("2", at: stringIndex)
                                                continue
                                            }
                                        }
                                        
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
                                .keyboardType(.numberPad)
                                .padding(10)
                                .background(Color.black.opacity(0.05))
                                .cornerRadius(10)
                                .accessibilityIdentifier("txtExpiredDate")
                                .onTapGesture {
                                    withAnimation {
                                        proxy.scrollTo(bottomID, anchor: .bottom)
                                    }
                                }
                                
                                HStack{
                                    Image(systemName: "creditcard.fill")
                                    TextField("CVV", text: .init(get: {
                                        card.secureCode
                                    }, set: { value in
                                        card.secureCode = value
                                        
                                        card.secureCode = String(card.secureCode.prefix(3))
                                    }))
                                    .keyboardType(.numberPad)
                                    .accessibilityIdentifier("txtCVV")
                                    .onTapGesture {
                                        withAnimation {
                                            proxy.scrollTo(bottomID, anchor: .bottom)
                                        }
                                    }
                                    
                                    
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
                                            .accessibilityIdentifier("errMsgExpiredDate")
                                        
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
                                            .accessibilityIdentifier("errMsgSecureCode")
                                    }else {
                                        Spacer()
                                    }
                                    
                                }
                            }
                        }.padding(.horizontal)
                        
                    }.frame(alignment: .top)
                    
                }
                
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
                    .accessibilityIdentifier("btnBack")
                    
                    Button {
                        payment()
                        
                    } label: {
                        Text("予約する")
                            .font(.system(size:16))
                            .foregroundColor(.white)
                            .padding(.horizontal,20)
                            .padding(10)
                            .background(Color.blue)
                            .cornerRadius(20)
                            .frame(height: 30)
                        
                    }
                    .accessibilityIdentifier("btnPayment")
                    
                }.alert(isPresented: $isShowingAlert){
                    Alert(title: Text("確認"),
                          message: Text("予約完了後はキャンセル料が発生します。予約を行いますか？"),
                          primaryButton: .default(Text("OK")){
                        saveOrder()
                    },
                          secondaryButton: .cancel(Text("キャンセル")))
                }
                .padding(10)
                .frame(alignment: .top)
        }
                Text("").id(bottomID)
            }
        }
        if isActive {
            Color.black.opacity(0.5).ignoresSafeArea(.all)
            DialogView(isShowDetail: $isActive,image: Image("success"), title: "予約が完了しました", message: "", buttonTitle: "OK") {
                isActive = false
                isPayment = false
                drafRoomOder.removeAll()
                total = 0
            }
        }
        
        if isWrongAccount {
            Color.black.opacity(0.5).ignoresSafeArea(.all)
            DialogView(isShowDetail: $isWrongAccount, image: Image("failure"), title: "失敗", message: "クレジットカード情報が誤っています。入力内容をご確認ください", buttonTitle: "OK") {
                isWrongAccount = false
            }
        }
        
    }
    

    func dismissOtherWindow(){
        let scene = UIApplication.shared.connectedScenes
        let windowScene = scene.first as? UIWindowScene
        let window = windowScene?.windows.first?.rootViewController
        window?.dismiss(animated: true)
    }
    func payment(){
        dismissOtherWindow()
        if !deferredPayment {
            isShowingAlert = true
        } else if (card.isCardNumberValid() && card.isNameValid() && card.isExpiredDateValid() && card.isSecureCodeValid()) {
            
            for cardCustomer in cards {
                if (cardCustomer.card_number == card.cardNumber.replacingOccurrences(of: " ", with: "") && cardCustomer.expired_date == card.expiredDate && cardCustomer.secure_code == card.secureCode){
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
            roomOrderController.addRoomOrder(userId: userId, roomId: draf.id, checkinDate: checkinDate, checkoutDate: checkoutDate, payment: deferredPayment)
            listRooms.removeAll(where: { $0.id == draf.id})
        }
        isActive = true
        
    }
}
