//
//  DialogView.swift
//  IOSDemo
//
//  Created by tester on 2023/04/03.
//

import SwiftUI

struct DialogView: View {
    @Binding var isShowDetail: Bool
    let image: Image
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> ()
    @State private var offset: CGFloat = 1000
    var body: some View {
        VStack{
            image
                .resizable()
                .frame(width: 50, height:50)
            Text(title)
                .font(.title2)
                .bold()
                .padding()
            Text(message)
                .font(.body)
            Button{
                action()
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.green)
                    Text("OK")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                }
                .padding()
            }
            .accessibilityIdentifier("btnOk")
            
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 20)
        .padding(30)
        .offset(x: 0, y: offset)
        .onAppear{
            withAnimation(.spring()){
                offset = 0
            }
        }
        
    }
    
    func close() {
        withAnimation(.spring()){
            offset = 1000
            isShowDetail = false
        }
    }
}



