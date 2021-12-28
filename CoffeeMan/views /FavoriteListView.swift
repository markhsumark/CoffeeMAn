//
//  FavoriteListView.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/26.
//

import SwiftUI

struct FavoriteListView: View {
    var body: some View {
        List{
            Text("咖啡廳1")
            Text("咖啡廳2")
            Text("咖啡廳3")
            Text("咖啡廳4")
        }
    }
}

struct FavoriteListView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteListView()
    }
}
