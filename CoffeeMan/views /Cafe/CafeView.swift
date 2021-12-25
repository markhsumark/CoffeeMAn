//
//  CafeList.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/7.
//

import SwiftUI

struct CafeView: View {
    
    @StateObject var Cafe = CafeViewModel()
    @State private var city : String = ""
    @State private var keywordToSearch = ""
    @State private var blockOrMapView : Bool = true
    var filtedCafes : [CafeItem]{
        if keywordToSearch.isEmpty{
            return Cafe.cafeItems
        }else{
            return Cafe.cafeItems.filter {
                $0.name.contains(keywordToSearch)
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing){
            if blockOrMapView{
                CafeBlockView(filtedCafes : filtedCafes)
            }else{
                Text("this is CafeMapView()")
            }
            Toggle(isOn: $blockOrMapView){
                if blockOrMapView{
                    Text("View in Map")
                }else{
                    Text("View in Block")
                }
            }
            .toggleStyle(.button)
            .padding()
        }
        .onAppear{
            if Cafe.cafeItems.isEmpty{
                Cafe.fetchCafe(term: city)
            }
        }
        .overlay{
            if Cafe.cafeItems.isEmpty{
                ProgressView()
            }
        }
        .searchable(text: $keywordToSearch)
    }
}


