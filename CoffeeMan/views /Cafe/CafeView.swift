//
//  CafeList.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/7.
//

import SwiftUI

struct FilterItem{
    var evaluation : Float
    var price : Float
}

struct CafeView: View {
    
    @StateObject var Cafe = CafeViewModel()
    @State private var city : String = ""
    @State private var searchText = ""
    @State private var blockOrMapView : Bool = false
    @State private var filterItem : FilterItem = FilterItem(evaluation: 0.0, price: 0.0)
    var filtedCafes : [CafeItem]{
        var fCafe : [CafeItem]{
            Cafe.cafeItems.filter { cafe in
                if cafe.tasty >= filterItem.evaluation{
                    return true
                }else{
                    return false
                }
            }
        }
        if searchText.isEmpty{
            return fCafe
        }else{
            return fCafe.filter {
                $0.name.contains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack{
            NavigationView{
                if blockOrMapView{

                    Text("this is CafeMapView()")
                        .navigationTitle("咖啡廳地圖")
                        .navigationBarItems(trailing: Button{
                            blockOrMapView = false
                        }label:{
                            Label("在列表中顯示", systemImage: "doc.text.magnifyingglass")
                        })
                }else{
                    CafeBlockView(filtedCafes: filtedCafes, filterItem: $filterItem, blockOrMapView: $blockOrMapView)
                        .navigationTitle("咖啡廳列表")
                        .navigationBarItems(trailing: Button{
                            blockOrMapView = true
                        }label:{
                            Label("在地圖中顯示", systemImage: "map")
                        })
                }
                
            }
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
        .searchable(text: $searchText)
    }
}


