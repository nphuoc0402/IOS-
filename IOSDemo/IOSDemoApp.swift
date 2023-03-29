//
//  IOSDemoApp.swift
//  IOSDemo
//
//  Created by EP_NonFunc on 2023/03/23.
//

import SwiftUI
enum CurrView:Int{
    case wellcome
    case login
    case home
}

class OpDat : ObservableObject {
    @Published var currView = CurrView.home
}
@main
struct IOSDemoApp: App {
    let persistenceController = PersistenceController.shared
    
    private var opDat = OpDat()
    @State var listRooms:[RoomModel] = []
    init(){
        
    }
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(opDat).environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
//        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext).environmentObject(roomViewModel)
//        }
    }
}
