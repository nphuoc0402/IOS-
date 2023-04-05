//
//  SideMenuView.swift
//  RoomOrder
//
//  Created by EP_NonFunc on 2023/03/17.
//

import SwiftUI


struct ItemMenuView: View {
    @EnvironmentObject var opDat:OpDat
    var body: some View {
        HStack(alignment: .center){
            Spacer()
            ZStack(alignment: .trailing){
                Menu{
                    Button("Order New Room",action: {
                        opDat.currView = .home
                        
                    })
                    Button("List Room Ordered",action: {
                        opDat.currView = .listOrderd
                        
                    })
                    Button("Logout",action: {
                        opDat.currView = .login
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


