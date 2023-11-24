//
//  ContentView.swift
//  COMP4097_HealthApp_groupG
//
//  Created by f0226942 on 17/11/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        TabView {
            
            StepDataView().tabItem {
                Image(systemName: "flame.fill")
                Text("Step")
            }
            GoalView().tabItem {
                Image(systemName: "star.circle.fill")
                Text("Goal")
            }
            RedeemView().tabItem {
                Image(systemName: "gift.fill")
                Text("Redeem")
            }
        }
//        .preferredColorScheme(darkMode ? .dark : .light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
