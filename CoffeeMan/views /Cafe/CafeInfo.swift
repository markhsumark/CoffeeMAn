//
//  CafeList.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/25.
//

import SwiftUI
import WebKit

struct CafeInfo: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Cafe.savedDate, ascending: true)], animation: .default)
    
    private var cafes : FetchedResults<Cafe>
    
    @State private var ifAdded = false
    @State private var showAlert = false
    
    var place : IdentifiablePlace
    var cafeData : CafeItem
    @Binding var showInfo : Bool
    
    @State private var isShowSheet : Bool = false
    @State private var isShared : Bool = false
    
    var cafeUrlStr : String{
        if cafeData.url != ""{
            return cafeData.url
        }else{
            return ""
        }
    }
    var body: some View {
        NavigationView{
            VStack{
                List{
                    VStack(alignment: .leading){
                        Text("店名：\(cafeData.name)")
                            .foregroundColor(Color.ui.titletext)
                            .font(.title3)
                        Text("地址：\(cafeData.address)")
                        Text("營業時間: \(cafeData.open_time)")
                        ScrollView(.horizontal){
                            HStack{
                                Label("\(cafeData.tasty, specifier: "%.1f")", systemImage: "star")
                                    .foregroundColor(Color.ui.orange)
                                Label("\(cafeData.cheap, specifier: "%.1f")", systemImage: "dollarsign.circle")
                                    .foregroundColor(.yellow)
                                Label("\(cafeData.music, specifier: "%.1f")", systemImage: "music.note")
                                Label("\(cafeData.wifi, specifier: "%.1f")", systemImage: "wifi.circle")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        if cafeUrlStr != ""{
                            Button{
                                isShowSheet.toggle()
                            }label:{
                                Text("網站連結(點我！)")
                                    .foregroundColor(.gray)
                            }
                            .buttonStyle(.plain)
                        }else{
                            Text("沒有相關網站資訊")
                        }
                    }
                    if let url = cafeData.url{
                        WebView(url : url)
                            .frame(height: 500)
                    }else{
//                        Spacer()
                        Text("沒有官方網頁鏈結")
//                        Spacer()
                    }
                    
                }
                HStack{
                    NavigationLink{
                        MapView(place: place, cafeName: cafeData.name)
                    }label:{
                        Rectangle()
                            .frame(width: 120, height: 40)
                            .foregroundColor(Color.ui.map)
                            .overlay{
                                Label("Map", systemImage: "map")
                                    .foregroundColor(.white)
                            }
                            .cornerRadius(20)
                            .padding(5)
                    }
                    if ifAdded == false{
                        Button{
                            ifAdded.toggle()
                            showAlert.toggle()
                            addItem(cafeData: cafeData)
                        }label:{
                            Rectangle()
                                .frame(width: 200, height: 40)
                                .overlay{
                                    Text("新增至喜好列表")
                                        .foregroundColor(.white)
                                }
                                .cornerRadius(20)
                                .padding(5)
                        }
                    }
                }

            }
            .alert("已加入喜好列表", isPresented: $showAlert) {
                Button("OK"){
                    showAlert = false
                }
            }
            .sheet(isPresented: $isShowSheet){
                SafariView(url: URL(string: cafeUrlStr)!)
            }
            .sheet(isPresented: $isShared){
                SharedView(title: cafeData.name
                           , url: cafeUrlStr)
            }
            .navigationBarTitle(Text("咖啡廳資訊"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                print("Dismissing sheet view...")
                self.showInfo = false
            }) {
                Text("Done").bold()
            })
            .navigationBarItems(leading: Button{
                self.isShared = true
            } label:{
                Image(systemName: "square.and.arrow.up")
            })
            
        }
    }
    private func addItem(cafeData : CafeItem) {
        withAnimation {
            let newItem = Cafe(context: viewContext)
            newItem.savedDate = Date()
            newItem.name = cafeData.name
            newItem.address = cafeData.address
            newItem.latitude = cafeData.latitude
            newItem.longitude = cafeData.longitude
            newItem.url = cafeData.url
            newItem.likeValue = 0.0
            newItem.beenTo = false
            do {
                
                try viewContext.save()
            } catch {
                //                Replace this implementation with code to handle the error
                //                appropriately.
                //                fatalError() causes the application to generate a crash log
                //                and terminate. You should not use this function in a shipping application,
                //                although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    var url : String = ""
    typealias UIViewType = WKWebView
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
