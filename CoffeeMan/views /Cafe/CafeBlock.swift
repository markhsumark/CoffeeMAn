//
//  CafeBlock.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/22.
//

import SwiftUI

struct CafeBlock: View {
    var cafe : CafeItem
    var body: some View {
        VStack{
            ScrollView(.horizontal, showsIndicators: false){
                Text("\(cafe.name)")
                    .foregroundColor(Color.ui.titletext)
                    .font(.title2)
                    .bold()
                    .padding(5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            Image("coffee-icon")
                .resizable()
                .scaledToFit()
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack {
                    Text("評分:\(cafe.tasty, specifier: "%.1f")")
                    Text("價位:\(cafe.cheap, specifier: "%.1f")")
                }
                .foregroundColor(Color.ui.text)
                .padding(5)
            }
        }
        .padding(5)
        .background(Color.ui.orange)
        .cornerRadius(10)
    }
}

//struct CafeBlock_Previews: PreviewProvider {
//    static var previews: some View {
//        CafeBlock()
//    }
//}
