import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var userName: String = "Sarah"
    @Published var recentDesigns: [Design] = []
    @Published var activeAlerts: [Alert] = []
    @Published var recentMatches: [Match] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // In a real implementation, this would fetch data from the API
        loadMockData()
    }
    
    private func loadMockData() {
        // Load mock designs
        recentDesigns = [
            Design(id: "1", name: "Summer Dress", thumbnail: "design-placeholder-1", createdAt: "April 10, 2025"),
            Design(id: "2", name: "Business Casual", thumbnail: "design-placeholder-2", createdAt: "April 5, 2025"),
            Design(id: "3", name: "Evening Gown", thumbnail: "design-placeholder-3", createdAt: "March 15, 2025")
        ]
        
        // Load mock alerts
        activeAlerts = [
            Alert(id: "1", designId: "1", designName: "Summer Dress", designThumbnail: "design-placeholder-1", status: .active, createdAt: "April 10, 2025"),
            Alert(id: "2", designId: "3", designName: "Evening Gown", designThumbnail: "design-placeholder-3", status: .active, createdAt: "March 15, 2025")
        ]
        
        // Load mock matches
        recentMatches = [
            Match(id: "1", designId: "1", product: Product(id: "p1", name: "Floral Summer Dress", price: 79.99, thumbnail: "product-placeholder-1", retailer: "Fashion Store"), matchScore: 92),
            Match(id: "2", designId: "2", product: Product(id: "p2", name: "Business Blazer", price: 129.99, thumbnail: "product-placeholder-2", retailer: "Style Hub"), matchScore: 87),
            Match(id: "3", designId: "1", product: Product(id: "p3", name: "Striped T-Shirt", price: 24.99, thumbnail: "product-placeholder-3", retailer: "Fashion Store"), matchScore: 78)
        ]
    }
    
    func fetchUserData() {
        // In a real implementation, this would fetch user data from the API
    }
    
    func fetchRecentDesigns() {
        // In a real implementation, this would fetch recent designs from the API
    }
    
    func fetchActiveAlerts() {
        // In a real implementation, this would fetch active alerts from the API
    }
    
    func fetchRecentMatches() {
        // In a real implementation, this would fetch recent matches from the API
    }
}
