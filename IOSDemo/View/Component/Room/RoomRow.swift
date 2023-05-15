//
//  RoomRow.swift
//  IOSDemo
//
//  Created by tester on 2023/03/28.
//

import SwiftUI

struct RoomRow: View {
    let isChecked: Bool
    let room: RoomModel
    let action: () -> Void
    
    var body: some View {
        ZStack{
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
                Spacer()
                Image(systemName: isChecked ? "checkmark.square" : "square")
                    .foregroundColor(isChecked ? .blue : .blue)
                    .onTapGesture {
                        self.action()
                    }
                    .font(.system(size: 30))
                    .accessibilityIdentifier("ckb-\(room.name)")
            }
            
            
        }
        
        
        
    }
}
