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
    @StateObject var roomViewModel : RoomViewModel = RoomViewModel()
    private var opDat = OpDat()
    init(){
        
    }
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(opDat).environment(\.managedObjectContext, persistenceController.container.viewContext).environmentObject(roomViewModel)
        }
//        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext).environmentObject(roomViewModel)
//        }
    }
}
