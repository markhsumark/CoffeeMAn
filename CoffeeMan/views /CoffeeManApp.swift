//
//  CoffeeManApp.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/7.
//

import SwiftUI

@main
struct CoffeeManApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,persistenceController.container.viewContext)
        }
        
    }
}
