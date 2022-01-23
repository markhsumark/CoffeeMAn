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
    @State private var blockOrMapView : Bool = false
    @State private var filterItem : FilterItem = FilterItem(evaluation: 0.0, price: 0.0)
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
                    CafeMapView(filterItem: $filterItem, blockOrMapView: $blockOrMapView)
                        .navigationTitle("咖啡廳地圖")
                        .navigationBarItems(trailing: Button{
                            blockOrMapView = false
                        }label:{
                            VStack{
                                Label("在列表中顯示", systemImage: "doc.text.magnifyingglass")
                                Text("列表")
                                    .font(.system(size: 15))
                            }
                           
                        })
                }else{
                    CafeBlockView(filterItem: $filterItem, blockOrMapView: $blockOrMapView)
                        .navigationTitle("咖啡廳列表")
                        .navigationBarItems(trailing: Button{
                            blockOrMapView = true
                        }label:{
                            VStack{
                                Label("在地圖中顯示", systemImage: "map")
                                Text("地圖")
                                    .font(.system(size: 15))
                            }
                        })
                }
                
            }
        }
        .environmentObject(Cafe)
    }

}


