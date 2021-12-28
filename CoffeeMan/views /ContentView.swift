//
//  ContentView.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/7.
//


import SwiftUI


struct ContentView: View {
    var body: some View {
        TabView{
            CafeNewsView()
                .tabItem{
                    Label("新聞", systemImage: "newspaper")
                }
            CafeView()
                .tabItem{
                    Label("咖啡廳", systemImage: "cup.and.saucer")
                }
            FavoriteListView()
                .tabItem{
                    Label("喜好列表", systemImage: "doc.plaintext")
                }
        }
        .tabViewStyle(DefaultTabViewStyle())
    }
}
extension Color {
    static let ui = Color.UI()
    
    struct UI {
        let orange = Color("orange")
        let titletext = Color("titletext")
        let text = Color("text")
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CafeList()
//    }
//}
