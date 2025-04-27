import Foundation
import Combine

/// Data store for managing application state
class AppDataStore {
    // Shared instance (singleton)
    static let shared = AppDataStore()
    
    // Repositories
    let userRepository = UserRepository()
    let designRepository = DesignRepository()
    let alertRepository = AlertRepository()
    let searchRepository = SearchRepository()
    
    // Published properties for app-wide state
    @Published var isInitialized: Bool = false
    @Published var isOfflineMode: Bool = false
    @Published var lastSyncTime: Date?
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        setupObservers()
        checkConnectivity()
    }
    
    /// Setup observers for repository changes
    private func setupObservers() {
        // Observe authentication state changes
        userRepository.$isAuthenticated
            .sink { [weak self] isAuthenticated in
                if isAuthenticated {
                    self?.refreshData()
                }
            }
            .store(in: &cancellables)
    }
    
    /// Check network connectivity
    private func checkConnectivity() {
        // In a real implementation, this would use Reachability to check network status
        isOfflineMode = false
    }
    
    /// Refresh all data from the server
    func refreshData() {
        guard !isOfflineMode else { return }
        
        designRepository.loadDesigns()
        alertRepository.loadAlerts()
        
        lastSyncTime = Date()
        isInitialized = true
    }
    
    /// Save local changes to server
    func syncLocalChanges() {
        guard !isOfflineMode else { return }
        
        // In a real implementation, this would sync any local changes to the server
        lastSyncTime = Date()
    }
    
    /// Handle going offline
    func handleOfflineMode() {
        isOfflineMode = true
        
        // In a real implementation, this would enable local caching
    }
    
    /// Handle coming back online
    func handleOnlineMode() {
        isOfflineMode = false
        refreshData()
    }
    
    /// Clear all data (for logout)
    func clearData() {
        // Clear all cached data when user logs out
        isInitialized = false
        lastSyncTime = nil
    }
}
