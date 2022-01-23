//
//  SharedViewModel.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2022/1/23.
//


import SwiftUI

struct SharedView : UIViewControllerRepresentable{
    let title : String
    let url : String
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [title,  URL(string: url)!], applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIActivityViewController
    
//
}
