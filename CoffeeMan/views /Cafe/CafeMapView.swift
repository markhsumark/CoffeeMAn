//
//  CafeMapView.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2022/1/1.
//

import SwiftUI

struct CafeMapView: View {
    @StateObject private var Cafe = CafeViewModelTest()
    var body: some View {
        Text("this is CafeMapView()")
            .onAppear {
                Cafe.fetchCafe(term: "")
            }
        
    }
}

//struct CafeMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        CafeMapView()
//    }
//}
