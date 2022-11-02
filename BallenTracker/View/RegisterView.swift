//
//  RegisterView.swift
//  BallenTracker
//
//  Created by Simon Goller on 08.08.22.
//

import SwiftUI

struct RegisterView: View {
    @State private var nameString: String = ""
    @State private var lastNameString: String = ""
    @State private var eMailString: String = ""
    @State private var passwordString: String = ""
    @State private var repeatPasswordString: String = ""

    
    var body: some View {
        VStack {
            Spacer()
            
            Image("Icon")
                .resizable()
                .frame(width: 150, height: 150)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3),
                        radius: 3,
                        x: 3,
                        y: 3)
            
            Text("Setup new Account")
                .font(.title)
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text("Name:")
                TextField ("enter your Name", text: $nameString)
                    .textFieldStyle(.roundedBorder)
                
                Text("Last Name:")
                TextField ("enter your Last Name", text: $lastNameString)
                    .textFieldStyle(.roundedBorder)
                
                Text("E-Mail:")
                TextField ("E-Mail", text: $eMailString)
                    .textFieldStyle(.roundedBorder)

                Text("Password:")
                TextField ("Password", text: $passwordString)
                    .textFieldStyle(.roundedBorder)

                Text("Repeat Password:")
                TextField ("Repeat Password", text: $repeatPasswordString)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.all, 16)
            
            Button (action: {
                // sign up account
            }, label: {
                Label("Sign Up", image: "person.circle.fill")
                    .font(.system(.title2))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(Color.white)
            })
            .padding([.leading, .trailing], 16)

            Spacer()
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
