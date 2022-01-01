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
    @State private var searchText = ""
    @State private var blockOrMapView : Bool = false
    @State private var filterItem : FilterItem = FilterItem(evaluation: 0.0, price: 0.0)
    var filtedCafes : [CafeItem]{
        var fCafe : [CafeItem]{
            Cafe.cafeItems.filter { cafe in
                if cafe.tasty >= filterItem.evaluation, cafe.cheap >= filterItem.price{
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
    //https://cafenomad.tw/taipei/map
    //
    //然後我最近有加一些咖啡相關的討論區功能
    //
    //- 咖啡廳相關
    //
    //https://cafenomad.tw/f/cafelover
    //
    //- 咖啡店家交流
    //
    //https://cafenomad.tw/f/cafeowner
    //
    //- 咖啡本身相關
    //
    //https://cafenomad.tw/f/coffee
    var body: some View {
        VStack{
            NavigationView{
                if blockOrMapView{
                    CafeMapView()
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
        .onAppear(perform: {
            Cafe.fetchCafe(term: "")
        })
        .overlay{
            if Cafe.cafeItems.isEmpty{
                ProgressView()
            }
        }
        .searchable(text: $searchText)
        .environmentObject(Cafe)
    }

}


