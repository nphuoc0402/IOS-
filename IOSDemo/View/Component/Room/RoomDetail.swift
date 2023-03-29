//
//  RoomDetail.swift
//  IOSDemo
//
//  Created by tester on 2023/03/28.
//

import SwiftUI

let backgroundGradient = LinearGradient(
    colors: [Color.red, Color.blue],
    startPoint: .top, endPoint: .bottom)

struct RoomDetail: View {
    @Environment(\.presentationMode) var presentationMode
    var room: RoomModel
    var body: some View {
        VStack(spacing: .zero){
            image
            roomName
            description
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 40)
        .multilineTextAlignment(.center)
        .border(.blue, width: 4)
        .overlay(alignment: .topTrailing){
            close
        }
  
    }
}

private extension RoomDetail {
    
    var close: some View{
        Button{
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
                .symbolVariant(.circle.fill)
                .font(.system(size: 35, weight: .bold,design: .rounded))
        }
        .foregroundStyle(.gray.opacity(0.4))
        .padding(8)
    }
    var image: some View{
        room.image
            .resizable()
            .frame(width: 50, height:50)
    }
    
    var roomName: some View{
        Text(room.name)
            .font(.system(size: 30,
                          weight: .bold,
                          design: .rounded))
            .padding()
    }
    
    var description: some View{
        Text(room.description)
            .font(.callout)
            .foregroundColor(.black.opacity(0.8))
    }
}



struct RoomDetail_Previews: PreviewProvider {
    static var previews: some View {
        RoomDetail(room: rooms[0])
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
