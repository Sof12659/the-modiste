import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var userName: String = "Sarah Johnson"
    @Published var userEmail: String = "sarah.johnson@example.com"
    @Published var profileImage: String = "profile-placeholder"
    @Published var designsCount: Int = 6
    @Published var alertsCount: Int = 2
    @Published var favoritesCount: Int = 3
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // In a real implementation, this would fetch user data from the API
    }
    
    func logout() {
        // In a real implementation, this would clear authentication tokens
        // and navigate to the login screen
        print("User logged out")
    }
}
