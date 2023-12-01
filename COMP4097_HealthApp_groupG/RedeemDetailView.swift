//
//  RedeemDetailView.swift
//  COMP4097_HealthApp_groupG
//
//  Created by f0226942 on 1/12/2023.
//

import SwiftUI

struct RedeemDetailView: View {
    
    @State var from: String
    @State var health: Health?
    @State var gift: Gift?
    
    var body: some View {
        if let h = health {
            Text("Hello, \(h.age)!")
        }
    }
}

//struct RedeemDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        RedeemDetailView()
//    }
//}
