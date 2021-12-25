//
//  CafeList.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/25.
//

import SwiftUI

struct CafeInfo: View {
    var place : IdentifiablePlace
    var cafeName : String
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            List{
                Text("Cafe info from IG")
                Text("Cafe info from IG")
                Text("Cafe info from IG")
                Text("Cafe info from IG")
                Text("Cafe info from IG")
            }
            .listStyle(.plain)
            NavigationLink{
                MapView(place: place, cafeName: cafeName)
            }label:{
                Rectangle()
                    .frame(width: 80, height: 40)
                    .foregroundColor(Color.ui.orange)
                    .overlay{
                        Label("Map", systemImage: "map")
                            .foregroundColor(.white)
                    }
                    .cornerRadius(20)
                    
            }
            
        }
    }
}
//
//struct CafeInfo_Previews: PreviewProvider {
//    static var previews: some View {
//        CafeInfo()
//    }
//}
