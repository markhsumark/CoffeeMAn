//
//  FavoriteListView.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/26.
//

import SwiftUI

struct FavoriteListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Cafe.savedDate, ascending: true)], animation: .default) private var cafes : FetchedResults<Cafe>
    
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
                print("fail to delete")
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
    @State var offset = CGSize.zero
    
    var dragGesture: some Gesture{
        DragGesture()
            .onChanged({value in
                offset = value.translation
            })
    }
    var body : some View{
        VStack(alignment: .leading){
            if let name = cafe.name{
                Text("\(name)")
                    .foregroundColor(Color.ui.titletext)
                    .font(.title2)
                    .bold()
                    .padding(5)
            }
            HStack{
                Text("個人評價:")
                Picker(selection: $selectedValue ){
                    Label("無", systemImage: "star")
                        .tag(0.0)
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
                }
                .pickerStyle(.menu)
                .onChange(of: selectedValue) { v in
                    modifyValue(cafe, value : Float(v))
                }
            }
            NavigationLink{
                if let lat = cafe.latitude, let long = cafe.longitude{
                    if let lat = Double(lat), let long = Double(long){
                        let actionPlace = IdentifiablePlace(id: UUID(), lat: lat, long: long)
                        MapView(place: actionPlace, cafeName: cafe.name!)
                    }
                }
            }label:{
                Rectangle()
                    .frame(width: 120, height: 40)
                    .foregroundColor(Color.ui.map)
                    .overlay{
                        Label("Map", systemImage: "map")
                            .foregroundColor(.white)
                    }
                    .cornerRadius(5)
                    .padding(5)
            }
            .buttonStyle(.plain)

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
                        .foregroundColor(Color.gray)
                        .padding(5)
                        .font(.system(size: 30))
                }
                .buttonStyle(.plain)
                
            }else{
                Button{
                    modifyBeenTo(cafe)
                }label:{
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(Color.gray)
                        .padding(5)
                        .font(.system(size: 30))
                }
                .buttonStyle(.plain)
            }
        }
        .offset(offset)
//        .gesture(
//            DragGesture()
//                .onChanged({value in
//                    offset = value.translation
//                })
//        )
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
