//
//  IOSDemoApp.swift
//  IOSDemo
//
//  Created by EP_NonFunc on 2023/03/23.
//

import SwiftUI
enum CurrView:Int{
    case listOrderd
    case login
    case home
}

class OpDat : ObservableObject {
    @Published var currView = CurrView.listOrderd
}

@main
struct IOSDemoApp: App {
    let persistenceController = PersistenceController.shared
    private var opDat = OpDat()
    init(){
        
    }
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(opDat).environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        
    }
}
