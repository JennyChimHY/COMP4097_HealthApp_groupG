//
//  LoginView.swift
//  COMP4097_HealthApp_groupG
//
//  Created by Tak Ting Ho on 24/11/2023.
//

import SwiftUI
import CoreData

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
//    @State private var loggedInUserID: String? = nil
    @AppStorage("loggedInUserID") var loggedInUserID = ""
    
    var onLoginSuccess: (String) -> Void
    
    var body: some View {
        ZStack {
                VStack {
                    Spacer().frame(height: 10)
                    
                    Text("Welcome back!")
                        .font(.title)
                        
                    
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
                        loggedInUserID = self.signUserIn(username: username, password: password) ?? ""
                    }) {
                        Text("Log In")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    
                    Spacer().frame(height: 30)
                    
                    HStack {
                        Text("Not a member?")
                            .font(.footnote)
                        Spacer().frame(width: 5)
                        NavigationLink(destination: RegistryView(onLoginSuccess:onLoginSuccess)) {
                            Text("Register Now")
                                .font(.footnote)
                                .foregroundColor(.cyan)
                                .fontWeight(.bold)
                        }
                    }
                }
                .padding()
            }
        .edgesIgnoringSafeArea(.all)
    }
    
//    func signUserIn() {
//            let correctPassword = "123456"
//            
//            if password == correctPassword {
//                print("Login successful")
//                onLoginSuccess(username)
//            } else {
//                print("Incorrect password")
//            }
//        
//        //login success: save the userID and username as the identifier in AppStorage / global var
//    }
    
    func signUserIn(username: String, password: String) -> String? {
        let viewContext = PersistenceController.shared.container.viewContext
            
        let fetchRequest: NSFetchRequest<Health> = Health.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)

        do {
            let users = try viewContext.fetch(fetchRequest)
            print(try viewContext.fetch(fetchRequest))
            print("Username: \(username), Password: \(password)")
            if let user = users.first {
                if user.password == password {
                    onLoginSuccess(username)
                    print(user.userID!)
                    return user.userID
                } else {
                    print("Incorrect password")
                    return nil
                }
            } else {
                print("Username not found")
                return nil
            }
        } catch let error as NSError {
            print("Fetch error: \(error), \(error.userInfo)")
            return nil
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(onLoginSuccess: { username in
            print("Logged in as: \(username)")
        })
    }
}


