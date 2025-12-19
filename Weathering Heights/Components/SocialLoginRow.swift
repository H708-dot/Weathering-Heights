import SwiftUI

struct SocialLoginRow: View {
    var onGoogle: () -> Void = {}
    var onApple: () -> Void = {}
    var onMicrosoft: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 25) {
            // Divider
            HStack(spacing: 15) {
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 1)
                
                Text("Or continue with")
                    .font(.custom("Rubik-Regular", size: 14))
                    .foregroundStyle(.white.opacity(0.7))
                
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 1)
            }
            
            // Buttons
            HStack(spacing: 30) {
                // Google
                Button(action: onGoogle) {
                    Circle()
                        .fill(.white)
                        .frame(width: 50, height: 50)
                        .overlay {
                            Text("G")
                                .font(.custom("Rubik-Bold", size: 28))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .red, .yellow, .green],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
                
                // Apple
                Button(action: onApple) {
                    Circle()
                        .fill(.black)
                        .frame(width: 50, height: 50)
                        .overlay {
                            Image(systemName: "apple.logo")
                                .font(.system(size: 24))
                                .foregroundStyle(.white)
                                .offset(y: -2)
                        }
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
                
                // Microsoft
                Button(action: onMicrosoft) {
                    Circle()
                        .fill(Color(UIColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 1))) // Dark background for MS
                        .frame(width: 50, height: 50)
                        .overlay {
                            Image(systemName: "square.grid.2x2.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(Color(UIColor(red: 0/255, green: 164/255, blue: 239/255, alpha: 1)))
                        }
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
            }
        }
        .padding(.top, 10)
    }
}

#Preview {
    ZStack {
        Color.gray
        SocialLoginRow()
    }
}
