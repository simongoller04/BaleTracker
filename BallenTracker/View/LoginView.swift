//
//  LoginView.swift
//  BallenTracker
//
//  Created by Simon Goller on 08.08.22.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var eMailLoginString: String = ""
    @State private var passwordLoginString: String = ""
    @State var isCreateAccount: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Image("Icon")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 3,
                            x: 3,
                            y: 3)
                
                Text("Login")
                    .font(.title)
                
                VStack(alignment: .leading, spacing: 8){
                    
                    Text("E-Mail:")
                    TextField("E-Mail", text: $eMailLoginString)
                        .textFieldStyle(.roundedBorder)
                    
                    Text("Password:")
                    TextField("", text: $passwordLoginString)
                        .background(
                            Label("Login", systemImage: "person.circle.fill")
                        )
                        .textFieldStyle(.roundedBorder)
                    
                }.padding(.all, 16)
                
                Button(action: {
                    viewModel.updateLoginStatus(success: true)
                }, label: {
                    Label("Login", systemImage: "person.circle.fill")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                        .background(.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .font(.system(.title2))
                })
                .padding([.leading, .trailing], 16)
                
                Button("Create Account?") {
                    isCreateAccount.toggle()
                }
                .padding(.top, 32)
                
                NavigationLink(destination: RegisterView(), isActive: $isCreateAccount) {}
            }
        }
        .animation(.easeInOut)
    }
}

struct LabelView: View {
    var body: some View {
        VStack {
            Image(systemName: "envelope.fill")
            Text("E-Mail:")
        }
    }
}
