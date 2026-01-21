//
//  Signup.swift
//  Weathering Heights
//
//  Created by Hemanth Sai Dasari on 01/07/2024.
//

import SwiftUI

struct SignUp: View {
    @Binding var showLogin: Bool
    
    @State private var emailId: String = ""
    @State private var fullName: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State var emailIdIsValid: Bool = true
    
    @ObservedObject private var authManager = AuthManager.shared
   
    var body: some View {
        VStack(spacing: 20) {
            /// Custom Text Fields
            CustomTF(sfIcon: "at", hint: "Email Id", value: $emailId)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .foregroundStyle(emailIdIsValid ? Color.green : Color.red)
                .onChange(of: emailId) { _, newValue in
                    if newValue.range(of: "^\\w+([-+.']\\w+)*@\\w+([-.](\\w+))*\\.\\w+([-.]\\w+)*$", options: .regularExpression) != nil {
                        self.emailIdIsValid = true
                    } else {
                        self.emailIdIsValid = false
                    }
                }
            
            CustomTF(sfIcon: "person", hint: "Full Name", value: $fullName)
                .padding(.top, 5)
                .textContentType(.name)
            
            CustomTF(sfIcon: "lock", hint: "Password", isPassword: true, value: $password)
                .padding(.top, 5)
                .textContentType(.newPassword)
            
            CustomTF(sfIcon: "lock", hint: "Confirm Password", isPassword: true, value: $confirmPassword)
                .padding(.top, 5)
                .textContentType(.newPassword)
            
            if !password.isEmpty && !confirmPassword.isEmpty && password != confirmPassword {
                Text("Passwords Don't Match")
                    .foregroundStyle(.red)
                    .font(.callout)
            }
            
            /// SignUp Button
            GradientButton(title: authManager.isLoading ? "Creating Account..." : "Sign Up", icon: "arrow.right") {
                Task {
                    await authManager.signUp(email: emailId, password: password, fullName: fullName)
                }
            }
            .foregroundColor(.white)
            .hSpacing(.trailing)
            .disableWithOpacity(
                emailId.isEmpty ||
                password.isEmpty ||
                fullName.isEmpty ||
                confirmPassword.isEmpty ||
                password != confirmPassword ||
                !emailIdIsValid ||
                authManager.isLoading
            )
            
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
        .alert("Sign Up Error", isPresented: $authManager.showError) {
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
