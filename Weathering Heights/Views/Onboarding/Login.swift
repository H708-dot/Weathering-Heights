//
//  Login.swift
//  login
//
//  Created by Hemanth Sai Dasari on 01/07/2024.
//

import SwiftUI

struct Login: View {
    @Binding var showLogin: Bool
    
    @State private var emailId: String = ""
    @State private var password: String = ""
    @State private var showForgetPasswordView: Bool = false
    @State private var showResetView: Bool = false
    
    @State var emailIdIsValid: Bool = true
    
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn: Bool = false
    
    var body: some View {
        VStack(spacing: 25) {
            /// Custom Text Fields
            CustomTF(sfIcon: "at", hint: "Email Id", value: $emailId)
                .autocapitalization(.none)
                .foregroundColor(emailIdIsValid ? .green : .red)
                .onChange(of: emailId) { newValue, _ in
                    if newValue.range(of: "^\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$", options: .regularExpression) != nil {
                        self.emailIdIsValid = true
                    } else {
                        self.emailIdIsValid = false
                    }
                }
            
            CustomTF(sfIcon: "lock", hint: "Password", isPassword: true, value: $password)
                .padding(.top, 5)
            
            Button("Forgot Password?") {
                showForgetPasswordView.toggle()
            }
            .foregroundStyle(.teal)
            .font(.callout)
            .fontWeight(.heavy)
            .tint(Color(UIColor(red: 7/255, green: 71/255, blue: 37/255, alpha: 1)))
            .hSpacing(.trailing)
            
            /// Login Button
            GradientButton(title: "Login", icon: "arrow.right") {
                // TODO: Implement actual auth logic here
                isUserLoggedIn = true
            }
                .hSpacing(.trailing)
                /// Disabling Until the Data is Entered
                .disableWithOpacity(emailId.isEmpty || password.isEmpty)
        }
        .padding(.top, 20)
        .sheet(isPresented: $showForgetPasswordView, content: {
            if #available(iOS 16.4, *) {
                ForgotPassword(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
                    .presentationCornerRadius(30)
            } else {
                ForgotPassword(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
            }
        })
    }
}

#Preview {
    LoginView()
}
