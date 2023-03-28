//
//  MainView.swift
//  RoomOrder
//
//  Created by EP_NonFunc on 2023/03/22.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var opDat:OpDat
    @EnvironmentObject var roomViewModel : RoomViewModel
    @State private var showMenu: Bool = false
    var body: some View {
        ZStack{
            NavigationView {
                ZStack {
                
                  switch(opDat.currView){
                  case .login:
                      LoginView()
                          .environmentObject(opDat)
                  case .home:
                      OrderView()
                          .environmentObject(opDat).environmentObject(roomViewModel)
                  case .wellcome:
                      WellcomeView()
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
        }.frame(alignment: .topLeading)
        
        
    }
}
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
