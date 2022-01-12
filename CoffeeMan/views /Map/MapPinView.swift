//
//  MapPinView.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/25.
//

import Foundation
import SwiftUI
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
                .frame(maxWidth: 30)
        }
    }
    
}

