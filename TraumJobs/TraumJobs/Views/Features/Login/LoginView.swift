//
//  LoginView.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 24.02.26.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.modelContext) private var context
    
    @Environment(SessionManager.self)
    private var session
    
    // MARK: - State for input fields
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var showSignUp: Bool = false
    
    var body: some View {
        
        VStack {
            AppTitleView()
            
            Spacer()
            
            VStack(spacing: 16) {
                // MARK: - Email & Password Fields
                EmailFieldView(email: $email, password: $password)
                PasswordFieldView(password: $password)
                
                // MARK: - Login Button
                LoginButtonView(action: login)
                
                // MARK: - Sign Up Button
                SignUpButtonView {
                    showSignUp = true
                }
                
                // MARK: - Login as gues Button
                GuestButtonView {
                    session.loginAsGuest(in: context)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            
            Spacer()
        }
        // MARK: - Alert for login errors
        .alert("Fehler", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("E-Mail oder Passwort ist falsch")
        }
        // MARK: - Present SignUpView sheet
        .sheet(isPresented: $showSignUp) {
            SignUpView { registeredEmail, registeredPassword in
                self.email = registeredEmail
                self.password = registeredPassword
            }
            .environment(\.modelContext, context)
            .environment(session)
        }
    }
    // MARK: - Login function
    private func login() {
        print("email: \(email) password: \(password)")
        if session.login(email: email, password: password, in: context) {
            print("Successfully logged in")
        } else {
            showAlert = true
    
        }
    }
}

// MARK: - App Title View
struct AppTitleView: View {
    var body: some View {
        Text("TraumJobs \nApp")
            .font(.system(size: 40))
            .multilineTextAlignment(.center)
            .bold()
            .padding(.top, 40)
            .padding(.bottom, 60)
    }
}

// MARK: - Email Field View
struct EmailFieldView: View {
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        HStack {
            TextField("E-Mail", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            if !email.isEmpty {
                Button(action: {
                    email = ""
                    password = ""
                }) {
                    Image(systemName: AppIcons.xmarkCircleFill)
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(10)
    }
}

// MARK: - Password Field View
struct PasswordFieldView: View {
    @Binding var password: String
    @State private var showPassword: Bool = false
    
    var body: some View {
        HStack {
            if showPassword {
                TextField("Passwort", text: $password)
                    .textContentType(.password)
            } else {
                SecureField("Passwort", text: $password)
                    .textContentType(.password)
            }
            
            Button(action: {
                showPassword.toggle()
            }) {
                Image(systemName: showPassword ? AppIcons.eyeSlash : AppIcons.eye)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(10)
    }
}

// MARK: - Login Button View
struct LoginButtonView: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Anmelden")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

// MARK: - Sign Up Button View
struct SignUpButtonView: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Registrieren")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 2)
        }
    }
}

// MARK: - Guest Button (menor e discreto)
struct GuestButtonView: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Login als Gast")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.clear)
                .foregroundColor(.blue)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue.opacity(0.6), lineWidth: 1.5)
                )
        }
        .padding(.top, 8)
    }
}

#Preview {
    LoginView()
        .environment(SessionManager())
}
