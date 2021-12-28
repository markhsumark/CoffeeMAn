//
//  CafeList.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/25.
//

import SwiftUI

struct CafeInfo: View {
    var place : IdentifiablePlace
    var cafeData : CafeItem
    @Binding var showInfo : Bool
    
    @State private var isShowSheet : Bool = false
    
    var cafeUrlStr : String{
        if cafeData.url != ""{
            return cafeData.url
        }else{
            return ""
        }
    }
    var body: some View {
        NavigationView{
            ZStack(alignment: .bottomTrailing){
                List{
                    if cafeUrlStr != ""{
                        Button("網站連結"){
                            isShowSheet = true
                        }
                    }
                }
                .listStyle(.plain)
                NavigationLink{
                    MapView(place: place, cafeName: cafeData.name)
                }label:{
                    Rectangle()
                        .frame(width: 80, height: 40)
                        .foregroundColor(Color.ui.orange)
                        .overlay{
                            Label("Map", systemImage: "map")
                                .foregroundColor(.white)
                        }
                        .cornerRadius(20)
                        .padding(15)
                    
                }
            }
            .sheet(isPresented: $isShowSheet){
                SafariView(url: URL(string: cafeUrlStr)!)
            }
            .navigationBarTitle(Text("咖啡廳"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                print("Dismissing sheet view...")
                self.showInfo = false
            }) {
                Text("Done").bold()
            })
        }
    }
}
//
//struct CafeInfo_Previews: PreviewProvider {
//    static var previews: some View {
//        CafeInfo()
//    }
//}
