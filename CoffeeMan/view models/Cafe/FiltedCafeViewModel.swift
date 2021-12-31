//
//  FiltedCafeViewModule.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/26.
//

import SwiftUI

class FiltedCafeViewModule: ObservableObject {
    
    var allCafes : [CafeItem]
    @Binding var keywordToSearch : String
    
    @Published var filtedCafe = [CafeItem]{
        if keywordToSearch.isEmpty{
            return allCafes.cafeItems
        }else{
            return allCafes.cafeItems.filter {
                $0.name.contains(keywordToSearch)
            }
        }
    }
    
    init(cafes : [CafeItem]){
        allCafes = cafes
    }
    
}
