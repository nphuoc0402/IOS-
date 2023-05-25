//
//  ContentView.swift
//  RoomOrder
//
//  Created by EP_NonFunc on 2023/03/14.
//


import SwiftUI
import CoreData

struct LoginView: View {
    @State var showAlert:Bool = false
    @State var email = ""
    @State var pw = ""
    @EnvironmentObject var opDat:OpDat
    @AppStorage("userId") var userId:String = ""
    @AppStorage("isLoggedIn") var isLoggedIn:Bool = false
    var body: some View {
        NavigationView{
            ZStack{
                Color.blue
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                VStack(spacing: 10){
                    Image("hotel")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .frame(alignment: .topTrailing)
                    Text("宿泊予約")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .accessibilityIdentifier("lblHeader")
                    TextField("メールアドレス",text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .keyboardType(.emailAddress)
                        .accessibilityIdentifier("txtEmail")
                    SecureField("パスワード",text: $pw)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .accessibilityIdentifier("txtPassword")
                    Button(action: {doLogin(email, pw)}) {
                        Text("ログイン")
                            .foregroundColor(.white)
                            .frame(width: 300,height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .accessibilityIdentifier("btnLogin")
                    
                }
            }
        }.alert(isPresented: $showAlert){
            Alert(title: Text("アカウントまたはパスワードが無効です"),
                  message: Text("有効なアカウントを入力してください"))
         
        }
        
    }
    func doLogin(_ email: String, _ pw: String){
        for user in users{
            if (email.lowercased() == user.email.lowercased() && pw == user.passwd) {
                opDat.currView = .home
                isLoggedIn = true
                userId = user.id
            }
        }
        showAlert = true
    }
}

