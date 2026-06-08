
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(SessionManager.self)
    private var session
    @Environment(\.modelContext) private var context
    
    var body: some View {
        Group {
            if session.isLoggedIn {
                RootView()
                    .environment(session)
            } else {
                LoginView()
                    .environment(session)
            }
        }
        .onAppear {
            session.restoreUser(in: context)
        }
    }
}

#Preview {
    ContentView()
        .environment(SessionManager())
}

