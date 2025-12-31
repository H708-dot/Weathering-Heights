//
//  Login.swift
//  Weathering Heights
//
//  Created by Hemanth Sai Dasari on 01/07/2024.
//

import SwiftUI

struct Login: View {
    @Binding var showLogin: Bool
    
    @State private var emailId: String = ""
    @State private var password: String = ""
    @State private var showForgetPasswordView: Bool = false
    
    @State var emailIdIsValid: Bool = true
    
    @ObservedObject private var authManager = AuthManager.shared
    
    var body: some View {
        VStack(spacing: 25) {
            /// Custom Text Fields
            CustomTF(sfIcon: "at", hint: "Email Id", value: $emailId)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .foregroundColor(emailIdIsValid ? .green : .red)
                .onChange(of: emailId) { newValue, _ in
                    if newValue.range(of: "^\\w+([-+.']\\w+)*@\\w+([-.](\\w+))*\\.\\w+([-.]\\w+)*$", options: .regularExpression) != nil {
                        self.emailIdIsValid = true
                    } else {
                        self.emailIdIsValid = false
                    }
                }
            
            CustomTF(sfIcon: "lock", hint: "Password", isPassword: true, value: $password)
                .padding(.top, 5)
                .textContentType(.password)
            
            Button("Forgot Password?") {
                showForgetPasswordView.toggle()
            }
            .foregroundStyle(.teal)
            .font(.callout)
            .fontWeight(.heavy)
            .tint(Color(UIColor(red: 7/255, green: 71/255, blue: 37/255, alpha: 1)))
            .hSpacing(.trailing)
            
            /// Login Button
            GradientButton(title: authManager.isLoading ? "Signing In..." : "Login", icon: "arrow.right") {
                Task {
                    await authManager.signIn(email: emailId, password: password)
                }
            }
            .hSpacing(.trailing)
            .disableWithOpacity(emailId.isEmpty || password.isEmpty || !emailIdIsValid || authManager.isLoading)
            
            SocialLoginRow(
                onGoogle: {
                    Task {
                        await authManager.signInWithGoogle()
                    }
                },
                onApple: {
                    authManager.signInWithApple()
                },
                onMicrosoft: {
                    Task {
                        await authManager.signInWithMicrosoft()
                    }
                }
            )
        }
        .frame(width: 350)
        .padding(.top, 20)
        .sheet(isPresented: $showForgetPasswordView) {
            if #available(iOS 16.4, *) {
                ForgotPassword()
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            } else {
                ForgotPassword()
                    .presentationDetents([.height(350)])
            }
        }
        .alert("Login Error", isPresented: $authManager.showError) {
            Button("OK", role: .cancel) {
                authManager.showError = false
            }
        } message: {
            Text(authManager.errorMessage ?? "An unknown error occurred")
        }
        .overlay {
            if authManager.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
    }
}

#Preview {
    LoginView()
}
