//
//  SessionManager.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 24.02.26.
//

import SwiftUI
import SwiftData
import Observation

@MainActor
@Observable
final class SessionManager {

    private let guestEmail = "guest@traumjobs.local"
    private let guestPassword = "guest"

    private(set) var currentUserId: UUID? {
        didSet {
            if let id = currentUserId {
                UserDefaults.standard.set(id.uuidString, forKey: "currentUserId")
            } else {
                UserDefaults.standard.removeObject(forKey: "currentUserId")
            }
        }
    }

    var isLoggedIn: Bool {
        currentUserId != nil
    }

    // MARK: - Restore user by ID
    func restoreUser(in context: ModelContext) {
        guard let idString = UserDefaults.standard.string(forKey: "currentUserId"),
              let uuid = UUID(uuidString: idString)
        else { return }

        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate<User> { $0.id == uuid }
        )

        if let savedUser = try? context.fetch(descriptor).first {
            currentUserId = savedUser.id
            print("Restored user: \(savedUser.email)")
        }
    }

    // MARK: - Login
    func login(email: String, password: String, in context: ModelContext) -> Bool {
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate<User> { $0.email == email }
        )

        guard let existingUser = try? context.fetch(descriptor).first else {
            return false
        }

        if existingUser.password == password {
            currentUserId = existingUser.id
            return true
        }

        return false
    }

    // MARK: - Logout
    func logout() {
        currentUserId = nil
    }

    // MARK: - Get valid user in the current context
    func currentUser(in context: ModelContext) -> User? {
        guard let uuid = currentUserId else { return nil }

        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate<User> { $0.id == uuid }
        )

        return try? context.fetch(descriptor).first
    }

    // MARK: - Login as Guest
    func loginAsGuest(in context: ModelContext) {

        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate<User> { $0.email == guestEmail }
        )

        if let existingGuest = try? context.fetch(descriptor).first {
            currentUserId = existingGuest.id
            print("Logged in as existing Guest")
            return
        }

        let guestUser = User(
            name: "Gast",
            password: guestPassword,
            email: guestEmail,
            birthDate: nil,
            city: ""
        )

        context.insert(guestUser)
        try? context.save()

        currentUserId = guestUser.id
        print("Created and logged in as Guest")
    }
}
