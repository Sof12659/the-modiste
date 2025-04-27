import Foundation
import Combine

/// Repository for managing user data and authentication
class UserRepository {
    private let apiClient = APIClient.shared
    private let userDefaults = UserDefaults.standard
    
    // Published properties for observing state changes
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    @Published var authError: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Check if user is already authenticated
        if let token = userDefaults.string(forKey: "authToken") {
            isAuthenticated = true
            loadCurrentUser()
        }
    }
    
    /// Login with email and password
    func login(email: String, password: String) -> AnyPublisher<User, Error> {
        return apiClient.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.currentUser = user
                self?.isAuthenticated = true
                self?.authError = nil
            }, receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.authError = error
                }
            })
            .eraseToAnyPublisher()
    }
    
    /// Register a new user
    func register(name: String, email: String, password: String) -> AnyPublisher<User, Error> {
        return apiClient.register(name: name, email: email, password: password)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.currentUser = user
                self?.isAuthenticated = true
                self?.authError = nil
            }, receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.authError = error
                }
            })
            .eraseToAnyPublisher()
    }
    
    /// Logout the current user
    func logout() {
        apiClient.logout()
        currentUser = nil
        isAuthenticated = false
        authError = nil
    }
    
    /// Load the current user's profile
    private func loadCurrentUser() {
        // In a real implementation, this would fetch the user profile from the API
        // For now, we'll create a mock user
        currentUser = User(
            id: "user123",
            name: "Sarah Johnson",
            email: "sarah.johnson@example.com",
            profileImage: "profile-placeholder"
        )
    }
    
    /// Update user profile
    func updateProfile(name: String, email: String) -> AnyPublisher<User, Error> {
        // In a real implementation, this would call the API to update the user profile
        // For now, we'll just update the local user object
        
        let updatedUser = User(
            id: currentUser?.id ?? "user123",
            name: name,
            email: email,
            profileImage: currentUser?.profileImage ?? "profile-placeholder"
        )
        
        return Just(updatedUser)
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.currentUser = user
            })
            .eraseToAnyPublisher()
    }
    
    /// Update user measurements
    func updateMeasurements(measurements: Measurements) -> AnyPublisher<Bool, Error> {
        // In a real implementation, this would call the API to update the user measurements
        // For now, we'll just return success
        
        return Just(true)
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// Update user style preferences
    func updateStylePreferences(styles: [String], colors: [String]) -> AnyPublisher<Bool, Error> {
        // In a real implementation, this would call the API to update the user style preferences
        // For now, we'll just return success
        
        return Just(true)
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

/// User model
struct User: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    let profileImage: String
}

/// User measurements model
struct Measurements: Codable {
    let bust: Double
    let waist: Double
    let hips: Double
    let height: Double
    let weight: Double
    let standardSize: String
}
