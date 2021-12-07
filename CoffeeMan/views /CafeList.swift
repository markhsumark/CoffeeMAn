//
//  CafeList.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/7.
//

import SwiftUI

struct CafeList: View {
    @StateObject var Cafe = CafeViewModel()
    @State private var city : String = ""
    var body: some View {
        NavigationView{
            List{
                ForEach(Cafe.cafeItems, id: \.id){cafe in
                    Text(cafe.name)
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
        }
    }
}

//struct CafeList_Previews: PreviewProvider {
//    static var previews: some View {
//        CafeList()
//    }
//}
