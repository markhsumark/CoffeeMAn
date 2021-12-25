//
//  MapView.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/22.
//

//import SwiftUI
import CoreLocationUI
import MapKit
import SwiftUI


struct MapView: View{
    @StateObject private var mapViewModel = MapViewModel()
    var place : IdentifiablePlace
    var cafeName : String
    var body: some View{
        ZStack(alignment: .bottom){
            
            Map(coordinateRegion: $mapViewModel.region, showsUserLocation: true, annotationItems: [place]){
                place in
                MapAnnotation(coordinate: place.location){
                    MapPinView(place: place, name : cafeName)
                }
                
            }
            .ignoresSafeArea()
            .accentColor(.blue)
            .onAppear {
                mapViewModel.checkIfLocationServicesIsEnable()
            }
            HStack{
                Button{
                    mapViewModel.changeRegion(location : place.location)
                }label:{
                    Rectangle()
                        .frame(width: 150, height: 40)
                        .foregroundColor(.red)
                        .cornerRadius(10)
                        .overlay(Label("Destinaton", systemImage: "mappin.circle")
                                    .foregroundColor(.white))
                }
                LocationButton(.currentLocation){
                    mapViewModel.requestAllowOnceLocationPermission()
                }
                .foregroundColor(.white)
                .cornerRadius(10)
                .labelStyle(.titleAndIcon)
                .symbolVariant(.fill)
            }
            .padding(.bottom, 50)
            
        }
    }
}

//struct MapView_Previews: PreviewProvider{
//    static var previews: some View{
//        MapView()
//    }
//}




