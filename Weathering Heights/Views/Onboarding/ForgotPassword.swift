//
//  ForgotPassword.swift
//  Weathering Heights
//
//  Created by Hemanth Sai Dasari on 04/07/2024.
//

import SwiftUI

struct ForgotPassword: View {
    @State private var emailId: String = ""
    @State var emailIdIsValid: Bool = true
    @State private var showSuccessAlert: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var authManager = AuthManager.shared
   
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            /// Back Button
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundStyle(.gray)
            })
            .padding(.top, 10)
            
            Text("Forgot Password?")
                .font(.custom("Rubik-Bold", fixedSize: 28))
                .padding(.top, 5)
            
            Text("Enter your email and we'll send you a link to reset your password.")
                .font(.caption)
                .foregroundStyle(.gray)
                .fontWeight(.semibold)
                .padding(.top, -5)
            
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
                
                /// Send Reset Link Button
                GradientButton(title: authManager.isLoading ? "Sending..." : "Send Reset Link", icon: "arrow.right") {
                    Task {
                        if await authManager.sendPasswordReset(email: emailId) {
                            showSuccessAlert = true
                        }
                    }
                }
                .hSpacing(.trailing)
                .disableWithOpacity(emailId.isEmpty || !emailIdIsValid || authManager.isLoading)
            }
            .padding(.top, 20)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .interactiveDismissDisabled()
        .alert("Reset Link Sent!", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("Check your email for a link to reset your password. If it doesn't appear within a few minutes, check your spam folder.")
        }
        .alert("Error", isPresented: $authManager.showError) {
            Button("OK", role: .cancel) {
                authManager.showError = false
            }
        } message: {
            Text(authManager.errorMessage ?? "Failed to send reset link")
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
    ForgotPassword()
}
