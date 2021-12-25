//
//  CafeBlockView.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/25.
//

import SwiftUI

struct CafeBlockView: View {
    var filtedCafes : [CafeItem]
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical){
                let columns = Array(repeating: GridItem(), count: 2)
                LazyVGrid(columns: columns, spacing: 20){
                    ForEach(filtedCafes, id: \.id){cafe in
                        NavigationLink{
                            if let lat = Double(cafe.latitude), let long = Double(cafe.longitude){
                                CafeInfo(place: IdentifiablePlace(id: UUID(), lat: lat, long: long), cafeName : cafe.name)
                            }
                        }label:{
                            CafeBlock(cafe: cafe)
                        }
                    }
                }
                .padding()
            }
        }
        
    }
}

