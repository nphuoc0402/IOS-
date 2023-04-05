//
//  TypePayment.swift
//  IOSDemo
//
//  Created by tester on 2023/03/30.
//

import SwiftUI

struct TypePayment: View {
    @ObservedObject var account = Account()
    @State private var wrongName = false
    @State private var wrongCardNumber = false
    @State var nameCustomer: String = ""
    @State var cardNumber = ""
    var body: some View {
        VStack(alignment: .center, spacing: 5){
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
            .frame(alignment: .topLeading)
            
            VStack(alignment: .leading, spacing: -10){
                VStack(spacing: 2){
                    TextField("名様を入力してください", text: $nameCustomer)
                        .padding(10)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .keyboardType(.decimalPad)
                }
                .padding()
                    
                VStack(spacing: 2){
                    HStack{
                        Image(systemName: "creditcard").foregroundColor(.gray)
                        TextField("名様を入力してください", text: $cardNumber)
                            .keyboardType(.decimalPad)
                    }
                    .padding(10)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                }
                .padding()

            }
  
        }
    }
}

//struct TypePayment_Previews: PreviewProvider {
//    static var previews: some View {
//        TypePayment()
//    }
//}
