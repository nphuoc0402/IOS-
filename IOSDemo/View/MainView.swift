//
//  MainView.swift
//  RoomOrder
//
//  Created by EP_NonFunc on 2023/03/22.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var opDat:OpDat
    @State private var showMenu: Bool = false
    @AppStorage("userId") var userId:String = ""
    @AppStorage("isLoggedIn") var isLoggedIn:Bool = false

    var body: some View {
        ZStack {
            
            switch(opDat.currView){
            case .login:
                LoginView()
                    .environmentObject(opDat)
            case .home:
                OrderView()
                    .environmentObject(opDat)
            case .listOrderd:
                ListOrderedView()
                    .environmentObject(opDat)
            }
            
            GeometryReader { _ in
                if(opDat.currView != .login) {
                    HStack {
                        ItemMenuView()
                        
                    }
                }
                
                
            }
            .background(Color.black.opacity(showMenu ? 0 : 0))
            
        }
        
        
        
    }
}

