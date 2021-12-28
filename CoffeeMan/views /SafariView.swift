//
//  SafariView.swift
//  CoffeeMan
//
//  Created by 徐易中 on 2021/12/26.
//

import SwiftUI

import SafariServices

struct SafariView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType =  SFSafariViewController
    
    let url : URL
}
struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView(url: URL(string: "https://medium.com/@apppeterpan")!)
    }
}
