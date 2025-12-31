//
//  AuthManager.swift
//  Weathering Heights
//
//  Complete Firebase Authentication Manager
//  Supports: Email/Password, Google, Apple, Microsoft
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
import CryptoKit

@MainActor
class AuthManager: NSObject, ObservableObject {
    static let shared = AuthManager()
    
    // MARK: - Published Properties
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentUser: User?
    @Published var showError = false
    
    // MARK: - Private Properties
    private var authStateListener: AuthStateDidChangeListenerHandle?
    private var currentNonce: String?
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        setupAuthStateListener()
    }
    
    deinit {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    // MARK: - Auth State Listener
    
    private func setupAuthStateListener() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUser = user
            }
        }
    }
    
    /// Check if user is currently logged in
    var isLoggedIn: Bool {
        return currentUser != nil
    }
    
    // MARK: - Email/Password Authentication
    
    /// Sign in with email and password
    func signIn(email: String, password: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            print("✅ Signed in successfully: \(result.user.email ?? "unknown")")
            isLoading = false
            return true
        } catch let error as NSError {
            isLoading = false
            handleAuthError(error)
            return false
        }
    }
    
    /// Create a new account with email and password
    func signUp(email: String, password: String, fullName: String? = nil) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            print("✅ Account created successfully: \(result.user.email ?? "unknown")")
            
            // Update display name if provided
            if let name = fullName, !name.isEmpty {
                let changeRequest = result.user.createProfileChangeRequest()
                changeRequest.displayName = name
                try await changeRequest.commitChanges()
            }
            
            isLoading = false
            return true
        } catch let error as NSError {
            isLoading = false
            handleAuthError(error)
            return false
        }
    }
    
    /// Send password reset email
    func sendPasswordReset(email: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            print("✅ Password reset email sent to: \(email)")
            isLoading = false
            return true
        } catch let error as NSError {
            isLoading = false
            handleAuthError(error)
            return false
        }
    }
    
    // MARK: - Google Sign In
    
    func signInWithGoogle() async -> Bool {
        isLoading = true
        errorMessage = nil
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            errorMessage = "Firebase configuration error"
            showError = true
            isLoading = false
            return false
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            errorMessage = "Cannot find root view controller"
            showError = true
            isLoading = false
            return false
        }
        
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            guard let idToken = result.user.idToken?.tokenString else {
                errorMessage = "Failed to get Google ID token"
                showError = true
                isLoading = false
                return false
            }
            
            let accessToken = result.user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            try await Auth.auth().signIn(with: credential)
            print("✅ Google Sign-In successful")
            isLoading = false
            return true
            
        } catch {
            isLoading = false
            if (error as NSError).code == GIDSignInError.canceled.rawValue {
                // User cancelled, don't show error
                return false
            }
            errorMessage = error.localizedDescription
            showError = true
            print("❌ Google Sign-In Error: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - Apple Sign In
    
    /// Start Apple Sign-In flow
    func signInWithApple() {
        isLoading = true
        errorMessage = nil
        
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    // MARK: - Microsoft Sign In
    
    func signInWithMicrosoft() async -> Bool {
        isLoading = true
        errorMessage = nil
        
        let provider = OAuthProvider(providerID: "microsoft.com")
        provider.customParameters = [
            "prompt": "consent",
            "login_hint": ""
        ]
        provider.scopes = ["mail.read", "user.read"]
        
        do {
            let credential = try await provider.credential(with: nil)
            try await Auth.auth().signIn(with: credential)
            print("✅ Microsoft Sign-In successful")
            isLoading = false
            return true
        } catch let error as NSError {
            isLoading = false
            
            // Check if user cancelled
            if error.code == AuthErrorCode.webContextCancelled.rawValue {
                return false
            }
            
            handleAuthError(error)
            print("❌ Microsoft Sign-In Error: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - Sign Out
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            currentUser = nil
            print("✅ Signed out successfully")
        } catch {
            print("❌ Sign out error: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    // MARK: - Error Handling
    
    private func handleAuthError(_ error: NSError) {
        let errorCode = AuthErrorCode(_nsError: error)
        
        switch errorCode.code {
        case .invalidEmail:
            errorMessage = "Invalid email address format"
        case .emailAlreadyInUse:
            errorMessage = "This email is already registered"
        case .weakPassword:
            errorMessage = "Password must be at least 6 characters"
        case .wrongPassword:
            errorMessage = "Incorrect password"
        case .userNotFound:
            errorMessage = "No account found with this email"
        case .networkError:
            errorMessage = "Network error. Please check your connection"
        case .tooManyRequests:
            errorMessage = "Too many attempts. Please try again later"
        case .userDisabled:
            errorMessage = "This account has been disabled"
        case .invalidCredential:
            errorMessage = "Invalid credentials. Please try again"
        default:
            errorMessage = error.localizedDescription
        }
        
        showError = true
        print("❌ Auth Error: \(errorMessage ?? "Unknown error")")
    }
    
    // MARK: - Apple Sign In Helpers
    
    /// Generate a random nonce string for Apple Sign-In
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        return String(nonce)
    }
    
    /// SHA256 hash for Apple Sign-In nonce
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        return hashString
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AuthManager: ASAuthorizationControllerDelegate {
    
    nonisolated func authorizationController(controller: ASAuthorizationController,
                                             didCompleteWithAuthorization authorization: ASAuthorization) {
        Task { @MainActor in
            guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                errorMessage = "Invalid Apple credential"
                showError = true
                isLoading = false
                return
            }
            
            guard let nonce = currentNonce else {
                errorMessage = "Invalid state: Nonce not found"
                showError = true
                isLoading = false
                return
            }
            
            guard let appleIDToken = appleIDCredential.identityToken,
                  let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                errorMessage = "Unable to fetch Apple ID token"
                showError = true
                isLoading = false
                return
            }
            
            // Create Firebase credential
            let credential = OAuthProvider.appleCredential(
                withIDToken: idTokenString,
                rawNonce: nonce,
                fullName: appleIDCredential.fullName
            )
            
            do {
                let result = try await Auth.auth().signIn(with: credential)
                
                // Update display name if available from Apple
                if let fullName = appleIDCredential.fullName {
                    let displayName = [fullName.givenName, fullName.familyName]
                        .compactMap { $0 }
                        .joined(separator: " ")
                    
                    if !displayName.isEmpty && result.user.displayName == nil {
                        let changeRequest = result.user.createProfileChangeRequest()
                        changeRequest.displayName = displayName
                        try await changeRequest.commitChanges()
                    }
                }
                
                print("✅ Apple Sign-In successful")
                isLoading = false
                
            } catch {
                errorMessage = error.localizedDescription
                showError = true
                isLoading = false
                print("❌ Apple Sign-In Firebase Error: \(error.localizedDescription)")
            }
        }
    }
    
    nonisolated func authorizationController(controller: ASAuthorizationController,
                                             didCompleteWithError error: Error) {
        Task { @MainActor in
            isLoading = false
            
            // Check if user cancelled
            if let authError = error as? ASAuthorizationError,
               authError.code == .canceled {
                return
            }
            
            errorMessage = error.localizedDescription
            showError = true
            print("❌ Apple Sign-In Error: \(error.localizedDescription)")
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AuthManager: ASAuthorizationControllerPresentationContextProviding {
    
    nonisolated func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return UIWindow()
        }
        return window
    }
}
