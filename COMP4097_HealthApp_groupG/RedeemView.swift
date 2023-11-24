//
//  RedeemView.swift
//  COMP4097_HealthApp_groupG
//
//  Created by f0226942 on 24/11/2023.
//

import SwiftUI

struct RedeemView: View {
    
    @State var steps = 300000
    
    var body: some View {
        VStack {
            Text("Gift Redemption")
                .padding()
                .font(.system(.title, weight: .bold))
            
            List(Gift.gifts) { gift in
                VStack(alignment: .center) { // Align items to the center
                    Image(gift.image)
                        .resizable()
                        .frame(width: 100.0, height: 100.0)
                        .cornerRadius(5)
                    
                    Text("Gift: \(gift.title)")
                    
                    Text("Steps to Redeem: \(gift.stepRequired)")
                    
                    if (steps > gift.stepRequired) {
                        Button(action: {
                            consume(required: gift.stepRequired)
                        }) {
                            Text("Redeem")
                                .font(.subheadline)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(8)
                                .frame(width: 100.0, height: 30.0)
                        }.padding()
                        
//                      .alert(alertTitle, isPresented: $showAlert, actions: {
//                            Button("OK") {}
//                            })
                        
                    } else {
                        Button(action: {}) {
                            Text("Redeem")
                                .font(.subheadline)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.gray)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity) // Expand the VStack horizontally
            }
            .frame(height: CGFloat(15) * CGFloat(45))
        }
        .frame(maxWidth: .infinity) // Expand the outer VStack horizontally
    }
}

extension RedeemView {
    func consume(required: Int) {
        steps = steps - required
    }
}

struct Gift: Identifiable {
    let id: String
    let title: String
    let image: String
    let stepRequired: Int
    var remaining: Int
}

extension Gift {
    static let gifts: [Gift] = [
        Gift(id: "bottle", title: "Water Bottles", image: "bottle", stepRequired: 400000, remaining: 200),
        Gift(id: "towel", title: "Sports Towel", image: "towel", stepRequired: 200000, remaining: 400),
        Gift(id: "chicken", title: "Instant Chicken Breast", image: "chicken", stepRequired: 50000, remaining: 1000),
    ]
}

struct RedeemView_Previews: PreviewProvider {
    let persistenceController = PersistenceController.shared
    static var previews: some View {
        RedeemView()
    }
}
