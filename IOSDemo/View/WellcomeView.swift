//
//  WelcomeView.swift
//  RoomOrder
//
//  Created by EP_NonFunc on 2023/03/22.
//

import SwiftUI

struct WellcomeView: View {
    var body: some View {
        ZStack{
            Text("Wellcome to My app")
        }.frame(alignment: .top)
        
    }
}

struct WellcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WellcomeView()
    }
}
