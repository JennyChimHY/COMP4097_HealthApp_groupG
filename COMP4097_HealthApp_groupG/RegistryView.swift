//
//  RegistryView.swift
//  COMP4097_HealthApp_groupG
//
//  Created by Tak Ting Ho on 24/11/2023.
//

import SwiftUI

struct RegistryView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    var onLoginSuccess: (String) -> Void
    
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 10)
                
                Text("Let's get started!")
                    .font(.title)
                    .foregroundColor(.black)
                
                Spacer().frame(height: 30)
                
                Image(systemName: "figure.run.circle.fill")
                    .resizable()
                    .frame(width:100, height: 100)
                //.imageScale(.large)
                
                TextField("Username", text: $username)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer().frame(height: 5)
                
                SecureField("Password", text: $password)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer().frame(height: 20)
                
                Button(action: {
                    self.signUserIn()
                }) {
                    Text("Sign In")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                
                Spacer().frame(height: 30)
                
                HStack {
                    Text("Already have an account?")
                        .font(.footnote)
                    Spacer().frame(width: 5)
                    NavigationLink(destination: LoginView(onLoginSuccess: onLoginSuccess)) {
                        Text("Login Now")
                            .font(.footnote)
                            .foregroundColor(.cyan)
                            .fontWeight(.bold)
                    }
                }
                .padding()
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    func signUserIn() {
            let correctPassword = "password"
            
            if password == correctPassword {
                print("Login successful")
                onLoginSuccess(username)
            } else {
                print("Incorrect password")
            }
    }
}

struct RegistryView_Previews: PreviewProvider {
    static var previews: some View {
        RegistryView(onLoginSuccess: {username in
            print("Logged in as: \(username)")
        })
    }
}
