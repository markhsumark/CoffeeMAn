//
//  CafeBlockView.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/25.
//

import SwiftUI


struct CafeBlockView: View {
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
    
    
    var body: some View {
        VStack(alignment: .trailing){
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
            
            ScrollView(.vertical){
                let columns = Array(repeating: GridItem(), count: 2)
                LazyVGrid(columns: columns, spacing: 20){
                    ForEach(filtedCafes, id: \.id){cafe in
                        CafeBlock(cafe: cafe)
                            .frame(height: 200)
                    }
                }
                .padding()
                .refreshable {
                    doReload()
                }
            }
            
        }
        .onAppear(perform: {
            Cafe.fetchCafe(term: "")

        })
        .overlay{
            if Cafe.cafeItems.isEmpty{
                ProgressView()
            }
        }
        .searchable(text: $searchText)
        .alert("沒有網路連線", isPresented: $Cafe.showError) {
            Button("OK"){
                Cafe.showError = false
            }
        }
    }
    func doReload(){
        Cafe.fetchCafe(term: cityTags[selectedCity]!)
    }
}



struct CafeBlock: View {
    
    var cafe : CafeItem
    @State private var showInfo : Bool = false
    @State private var showBlock : Bool = false
    var body: some View {
        Button{
            showInfo.toggle()
        }label:{
            VStack{
                
                Text("\(cafe.name)")
                    .foregroundColor(Color.ui.titletext)
                    .font(.title2)
                    .bold()
                    .padding(5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
                //                Image("coffee-icon")
                //                    .resizable()
                //                    .scaledToFit()
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack {
                        Text("評分:\(cafe.tasty, specifier: "%.1f")")
                        Text("價位:\(cafe.cheap, specifier: "%.1f")")
                    }
                    .foregroundColor(Color.ui.text)
                    .padding(5)
                }
                .transition(.slide)
            }
            .onAppear(perform: {
                showBlock = true
            })
            .onDisappear(perform: {
                showBlock = false
            })
            .animation(.easeInOut, value: showBlock)
            .padding(5)
            .background(Color.ui.orange)
            .cornerRadius(10)
            
        }
        
        .sheet(isPresented: $showInfo){
            if let lat = Double(cafe.latitude), let long = Double(cafe.longitude){
                let actionPlace = IdentifiablePlace(id: UUID(), lat: lat, long: long)
                CafeInfo(place: actionPlace, cafeData : cafe, showInfo: $showInfo)
            }
        }
        
    }

}
