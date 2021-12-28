//
//  CafeBlockView.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/25.
//

import SwiftUI

struct CafeBlockView: View {
    var filtedCafes : [CafeItem]
    @Binding var filterItem : FilterItem
    @Binding var blockOrMapView : Bool
    
    @State private var showInfo : Bool = false
    @State private var showSliderOfValue : Bool = false
    
    
    var body: some View {
        VStack(alignment: .trailing){
            HStack{
                Toggle(isOn: $showSliderOfValue){
                    Label("評價", systemImage: "slider.horizontal.3")
                }
                .toggleStyle(.button)
                .padding(5)
            }
            .frame(maxHeight: 50)
            if showSliderOfValue{
                HStack{
                    Text("\(filterItem.evaluation, specifier: "%.1f")")
                    Spacer()
                    Slider(value: $filterItem.evaluation, in: 0.0...5.0)
                    
                }
                .padding(.leading, 30)
                .padding(.trailing, 30)
            }
            
            ScrollView(.vertical){
                let columns = Array(repeating: GridItem(), count: 2)
                LazyVGrid(columns: columns, spacing: 20){
                    ForEach(filtedCafes, id: \.id){cafe in
                        Button{
                            showInfo.toggle()
                        }label:{
                            CafeBlock(cafe: cafe)
                        }
                        .sheet(isPresented: $showInfo){
                            if let lat = Double(cafe.latitude), let long = Double(cafe.longitude){
                                let actionPlace = IdentifiablePlace(id: UUID(), lat: lat, long: long)
                                CafeInfo(place: actionPlace, cafeData : cafe, showInfo: $showInfo)
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}

