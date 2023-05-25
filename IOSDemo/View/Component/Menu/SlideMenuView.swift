//
//  SideMenuView.swift
//  RoomOrder
//
//  Created by EP_NonFunc on 2023/03/17.
//

import SwiftUI


struct ItemMenuView: View {
    @EnvironmentObject var opDat:OpDat
    @AppStorage("userId") var userId:String = ""
    @AppStorage("isLoggedIn") var isLoggedIn:Bool = false
    var body: some View {
        HStack(alignment: .center){
            Spacer()
            ZStack(alignment: .trailing){
                Menu{
                    Button("宿泊予約",action: {
                        opDat.currView = .home
                        
                    }).accessibilityIdentifier("部屋を予約する")
                    Button("予約した部屋リスト",action: {
                        opDat.currView = .listOrderd
                        
                    }).accessibilityIdentifier("部屋を予約したリスト")
                    Button("ログアウト",action: {
                        opDat.currView = .login
                        userId = ""
                        isLoggedIn = false
                    }).accessibilityIdentifier("ログアウト")
                    
                }label: {
                    Image(systemName: "text.justify")
                }
                .accessibilityIdentifier("menu")
                
            }
            .font(.title)
            .padding()
            
        }
    }
    
}


