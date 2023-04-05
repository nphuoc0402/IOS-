//
//  ContentView.swift
//  RoomOrder
//
//  Created by EP_NonFunc on 2023/03/14.
//


import SwiftUI
import CoreData

struct LoginView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State var showAlert:Bool = false
    @State var email = ""
    @State var pw = ""
    @EnvironmentObject var opDat:OpDat
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
                    
                    Text("予約室")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    TextField("メール",text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .keyboardType(.emailAddress)
                
                    
                    SecureField("パスワード",text: $pw)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    Button("ログイン") {
                        doLogin(email, pw)
                    }
                    .foregroundColor(.white)
                    .frame(width: 300,height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
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
                }
            }
            showAlert = true
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
        }
    }
}

