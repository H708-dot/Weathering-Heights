//
//  ForgotPassword.swift
//  Weathering Heights
//
//  Created by Hemanth Sai Dasari on 04/07/2024.
//

import SwiftUI

struct ForgotPassword: View {
    @Binding var showResetView: Bool
    
    @State private var emailId: String = ""
    
    @State var emailIdIsValid: Bool = true
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var askOTP: Bool = false
    @State private var showResetPassword: Bool = false
    @State private var otpText: String = ""
   
    var body: some View {
        ZStack {
            Image("Background2")
                .resizable()
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 15, content: {
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
                
                Text("Please enter the email associated with your account.")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .fontWeight(.semibold)
                    .padding(.top, -5)
                
                VStack(spacing: 25) {
                    /// Custom Text Fields
                    CustomTF(sfIcon: "at", hint: "Email Id", value: $emailId)
                        .autocapitalization(.none)
                        .foregroundColor(emailIdIsValid ? Color.green : Color.red)
                        .onChange(of: emailId) { newValue, _ in
                            if newValue.range(of: "^\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$", options: .regularExpression) != nil {
                                self.emailIdIsValid = true
                            } else {
                                self.emailIdIsValid = false
                            }
                        }
                    
                    /// SignUp Button
                    GradientButton(title: "Send OTP", icon: "arrow.right") {
                        /// Code after link sent
                        askOTP.toggle()
                    }
                    .hSpacing(.trailing)
                    /// Disabling Until the Data is Entered
                    .disableWithOpacity(emailId.isEmpty || !emailIdIsValid)
                }
                .padding(.top, 20)
            })
            .padding(.vertical, 15)
            .padding(.horizontal, 25)
            .interactiveDismissDisabled()
            .sheet(isPresented: $askOTP, content: {
                if #available(iOS 16.4, *) {
                    OTPView(otpText: $otpText, onVerify: {
                        showResetPassword = true
                    })
                        .presentationDetents([.height(350)])
                        .presentationCornerRadius(30)
                        .sheet(isPresented: $showResetPassword) {
                            if #available(iOS 16.4, *) {
                                PasswordResetView()
                                    .presentationDetents([.height(350)])
                                    .presentationCornerRadius(30)
                            } else {
                                PasswordResetView()
                                    .presentationDetents([.height(350)])
                            }
                        }
                } else {
                    OTPView(otpText: $otpText, onVerify: {
                         showResetPassword = true
                    })
                        .presentationDetents([.height(350)])
                        .sheet(isPresented: $showResetPassword) {
                            PasswordResetView()
                                .presentationDetents([.height(350)])
                        }
                }
            })
        }
    }
}

#Preview {
    LoginView()
}
