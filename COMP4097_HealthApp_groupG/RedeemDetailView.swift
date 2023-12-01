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
            if let g = gift {
                VStack() {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                    
                    Text("Redeem Success!").font(.largeTitle)
                    Text("Ref. No.: \(String(Int(arc4random_uniform(90000000) + 10000000)))").font(.footnote)
                    
                    Spacer()
                    
                    Image(g.image)
                        .resizable()
                        .frame(width: 200.0, height: 200.0)
                        .cornerRadius(5)
                    
                    Text("\(g.title)").font(.headline)
                    Text("Remaining: \(g.remaining)").padding()
                        
                    HStack() {
                        VStack(alignment: .trailing) {
                            Text("Required Points: ")
                            Text("Updated Available Points: ")
                        }
                        
                        VStack(alignment: .trailing) {
                            Text("\(g.stepRequired)")
                            Text("\(h.accumulateStep - h.redemmedStep)")
                        }
                    }
                        
                    Text("*Redeemption = Points - Required Points").font(.footnote).padding()
                    
                    Spacer()
                }
            }
        }
    }
}

extension RedeemDetailView {
    func test() {
        print(health ?? 440)
    }
}
//struct RedeemDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        RedeemDetailView()
//    }
//}
