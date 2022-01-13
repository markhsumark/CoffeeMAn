//
//  MapPinView.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/25.
//

import Foundation
import SwiftUI

struct PinView: View{
    var cafe : CafeItem
    var place : IdentifiablePlace
    
    @State private var showInfo = false
    
    var body: some View{
        Button{
            showInfo = true
        }label:{
            MapPinView(place: place, name: cafe.name)
        }
        .sheet(isPresented: $showInfo){
            if let lat = Double(cafe.latitude), let long = Double(cafe.longitude){
                let actionPlace = IdentifiablePlace(id: UUID(), lat: lat, long: long)
                CafeInfo(place: actionPlace, cafeData : cafe, showInfo: $showInfo)
            }
        }
    }
}
struct MapPinView : View{
    var place : IdentifiablePlace
    var name : String
    var body : some View{
        
        VStack(spacing: 0) {
            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .foregroundColor(.red)
            
            Image(systemName: "arrowtriangle.down.fill")
                .font(.caption)
                .foregroundColor(.red)
                .offset(x: 0, y: -5)
            Text(name)
                .foregroundColor(.red)
                .cornerRadius(8)
                .font(.system(size: 10))
                .frame(maxWidth: 140)
        }
    }
    
}

