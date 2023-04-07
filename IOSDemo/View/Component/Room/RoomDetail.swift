//
//  RoomDetail.swift
//  IOSDemo
//
//  Created by tester on 2023/03/28.
//


import SwiftUI

struct RoomDetail: View {
    @Binding var isShowDetail: Bool
    var roomDetail: RoomModel?
    let action: () -> ()
    @State var offset: CGFloat = 2000
    
    var body: some View {
        return ZStack{
            Color(.black)
                .opacity(0.3)
                .onTapGesture {
                    close()
                }
            
            VStack{
                roomDetail?.image
                    .resizable()
                    .frame(width: 100, height:100)
                Text("部屋:   \(roomDetail?.name ?? "")")
                    .font(.system(size:15))
                Text("価格: ¥\(roomDetail?.price ?? 0)")
                    .font(.system(size:15))
                Text("タイプ: \(roomDetail?.type ?? "")")
                    .font(.system(size:15))
                Text("タイプ: \(roomDetail?.floor ?? "")")
                    .font(.system(size:15))
                Text("タイプ: \(roomDetail?.description ?? "")")
                    .font(.system(size:15))
                Button{
                    close()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.red)
                        Text("OK")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                    }
                    .padding()
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 20)
            .padding(30)
        }
        .ignoresSafeArea()
        
    }
    
    func close() {
        withAnimation(.spring()){
            offset = 2000
            isShowDetail = false
        }
    }
    
}
