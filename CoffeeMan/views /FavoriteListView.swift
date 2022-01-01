//
//  FavoriteListView.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/26.
//

import SwiftUI

struct FavoriteListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Cafe.savedDate, ascending: true)], animation: .default)
    
    private var cafes : FetchedResults<Cafe>
    
    var body: some View {
        NavigationView{
            List{
                Section(header: Text("想去的咖啡廳")){
                    ForEach(cafes){cafe in
                        if cafe.beenTo == false{
                            
                            likeListItem(cafe: cafe)
                        }
                    }
                    .onDelete(perform: deleteItem)
                }
                Section(header: Text("去過的咖啡廳")){
                    ForEach(cafes){cafe in
                        if cafe.beenTo{
                            likeListItem(cafe: cafe)
                        }
                    }
                    .onDelete(perform: deleteItem)
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .navigationTitle("喜好列表")
            
        }
    }
    private func deleteItem(offsets: IndexSet){
        withAnimation {
            offsets.map{ cafes[$0] }.forEach(viewContext.delete)
            do{
                try viewContext.save()
            }catch{
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

}

struct likeListItem: View{
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var cafe : Cafe
    @State private var selectedValue = 0.0
    var body : some View{
        VStack(alignment: .leading){
            Text("\(cafe.name!)")
                .foregroundColor(Color.ui.titletext)
                .font(.title2)
                .bold()
                .padding(5)
            Picker(selection: $selectedValue ){
                Label("5", systemImage: "star")
                    .tag(5.0)
                Label("4", systemImage: "star")
                    .tag(4.0)
                Label("3", systemImage: "star")
                    .tag(3.0)
                Label("2", systemImage: "star")
                    .tag(2.0)
                Label("1", systemImage: "star")
                    .tag(1.0)
                Label("0", systemImage: "star")
                    .tag(0.0)
            }label:{
                Image(systemName: "star")
                Text("個人評價\(cafe.likeValue, specifier: "%.0f")")
            }
            .pickerStyle(.menu)
            .onChange(of: selectedValue) { v in
                modifyValue(cafe, value : Float(v))
            }
            NavigationLink{
                if let lat = Double(cafe.latitude!), let long = Double(cafe.longitude!){
                    let actionPlace = IdentifiablePlace(id: UUID(), lat: lat, long: long)
                    MapView(place: actionPlace, cafeName: cafe.name!)
                }
            }label:{
                Rectangle()
                    .frame(width: 120, height: 40)
                    .foregroundColor(Color.ui.orange)
                    .overlay{
                        Label("Map", systemImage: "map")
                            .foregroundColor(.white)
                    }
                    .cornerRadius(5)
                    .padding(5)
            }
        }
        .onAppear(perform: {
            selectedValue = Double(cafe.likeValue)
        })
        .overlay(alignment: .topTrailing){
            if cafe.beenTo{
                Button{
                    modifyBeenTo(cafe)
                }label:{
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .padding(5)
                        .font(.system(size: 30))
                }
                .buttonStyle(.plain)
                
            }else{
                Button{
                    modifyBeenTo(cafe)
                }label:{
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.blue)
                        .padding(5)
                        .font(.system(size: 30))
                }
                .buttonStyle(.plain)
            }
        }
    }
    private func modifyBeenTo(_ cafe: Cafe){
        withAnimation {
            cafe.beenTo.toggle()
            do{
                try viewContext.save()
            }catch{
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    private func modifyValue(_ cafe: Cafe, value : Float){
        withAnimation {
            cafe.likeValue = value
            do{
                try viewContext.save()
            }catch{
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
