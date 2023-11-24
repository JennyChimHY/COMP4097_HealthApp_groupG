//
//  ContentView.swift
//  COMP4097_HealthApp_groupG
//
//  Created by f0226942 on 17/11/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var username: String = ""

    var body: some View {
        if isLoggedIn {
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
                    Text("Gift Redemption")
                }
            }
            //.preferredColorScheme(darkMode ? .dark : .light)
        } else {
            LoginView(onLoginSuccess: { enteredUsername in
                self.username = enteredUsername
                self.isLoggedIn = true
            })
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    let persistenceController = PersistenceController.shared
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
