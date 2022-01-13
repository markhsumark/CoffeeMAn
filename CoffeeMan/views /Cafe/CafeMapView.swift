//
//  CafeMapView.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2022/1/1.
//

import CoreLocationUI
import MapKit
import SwiftUI

struct pin: Identifiable{
    let id: UUID
    var cafe : CafeItem
    var place : IdentifiablePlace
    var name : String
}
struct CafeMapView: View{
    @State private var searchText = ""
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
    
    @EnvironmentObject var Cafe : CafeViewModel
    @StateObject private var mapViewModel = MapViewModel()
    
    @Binding var filterItem : FilterItem
    @Binding var blockOrMapView : Bool
    
    @State private var showSliderCheap : Bool = false
    @State private var showSliderTasty : Bool = false
    @State private var selectedCity = "全部"
    @State private var selectedCafe = CafeItem(id: "", name: "", wifi: 0.0, city: "", seat: 0.0, tasty: 0.0, cheap: 0.0, music: 0.0, url: "", address: "", open_time: "", mrt: "", latitude: "", longitude: "")
    
    //各縣市縮寫：https://www.thinkclub.com.tw/台灣縣市英文及英文縮寫/
    let cityTags = ["台北": "Taipei", "基隆": "Keelung", "桃園": "Taoyuan",
                    "新竹": "Hsinchu", "苗栗": "Miaoli", "台中": "Taichung",
                    "彰化": "Changhua", "南投": "Nantou", "雲林": "Yunlin",
                    "嘉義": "Chiayi", "台南": "Tainan", "高雄": "Kaohsiung",
                    "屏東": "Pingtung", "宜蘭": "Yilan", "花蓮": "Hualien",
                    "台東": "Taitung", "連江": "Lienchiang ", "澎湖": "Penghu"]
    
    var pinlist : [pin]{
        var pins : [pin] = []
        for cafe in filtedCafes{
            if let lat = Double(cafe.latitude), let long = Double(cafe.longitude){
                let actionPlace = IdentifiablePlace(id: UUID(), lat: lat, long: long)
                let name = cafe.name
                pins.append(pin(id : UUID(),cafe: cafe, place : actionPlace, name: name))
            }
        }
        return pins
    }
    var body: some View{
        VStack{
            HStack{
                Picker(selection: $selectedCity){
                    ForEach(cityTags.sorted(by: >) , id: \.key){key, value in
                        Text("縣市:\(key)")
                            .tag(key)
                    }
                }label:{
                    Image(systemName: "map")
                }
                .frame(width: 100)
                .onChange(of: selectedCity) { v in
                    doReload()
                }
                Toggle(isOn: $showSliderTasty){
                    Label("評價", systemImage: "slider.horizontal.3")
                }
                .frame(width: 100)
                .toggleStyle(.button)
                .padding(5)
                Toggle(isOn: $showSliderCheap){
                    Label("價位", systemImage: "slider.horizontal.3")
                }
                .frame(width: 100)
                .toggleStyle(.button)
                .padding(5)
            }
            .frame(maxHeight: 40)
            if showSliderCheap{
                HStack{
                    Text("價位:\(filterItem.price, specifier: "%.1f")")
                    Spacer()
                    Slider(value: $filterItem.price, in: 0.0...5.0)
                }
                .padding(.leading, 30)
                .padding(.trailing, 30)
            }
            if showSliderTasty{
                HStack{
                    Text("評價:\(filterItem.evaluation, specifier: "%.1f")")
                    Spacer()
                    Slider(value: $filterItem.evaluation, in: 0.0...5.0)
                }
                .padding(.leading, 30)
                .padding(.trailing, 30)
            }
        
            ZStack(alignment: .bottom){
                let center = $mapViewModel.region.center
                let leftTop = CLLocationCoordinate2D()
                Map(coordinateRegion: $mapViewModel.region, showsUserLocation: true, annotationItems: pinlist){
                    pin in
                    MapAnnotation(coordinate: pin.place.location){
                        PinView(cafe: pin.cafe, place: pin.place)
                    }
                }
                .ignoresSafeArea()
                .accentColor(.blue)
                .onAppear {
                    mapViewModel.checkIfLocationServicesIsEnable()
                }
                LocationButton(.currentLocation){
                    mapViewModel.requestAllowOnceLocationPermission()
                }
                .foregroundColor(.white)
                .cornerRadius(10)
                .labelStyle(.titleAndIcon)
                .symbolVariant(.fill)
                    
            }
        }
        .searchable(text: $searchText)
        .alert("沒有網路連線", isPresented: $Cafe.showError){
            Button("OK"){
                Cafe.showError = false
            }
        }
    }
    func doReload(){
        Cafe.fetchCafe(term: cityTags[selectedCity]!)
    }
    
}

