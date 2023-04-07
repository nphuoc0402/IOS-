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
                    Button("部屋を予約する",action: {
                        opDat.currView = .home
                        
                    })
                    Button("部屋を予約したリスト",action: {
                        opDat.currView = .listOrderd
                        
                    })
                    Button("ログアウト",action: {
                        opDat.currView = .login
                        userId = ""
                        isLoggedIn = false
                    })
                    
                }label: {
                    Image(systemName: "text.justify")
                }
                
            }
            .font(.title)
            .padding()
            
        }
    }
    
}


