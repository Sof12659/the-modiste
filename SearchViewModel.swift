import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var recentDesigns: [Design] = []
    @Published var categories: [String] = ["Dresses", "Tops", "Bottoms", "Outerwear", "Accessories"]
    @Published var recentSearches: [String] = ["summer dress", "blue jeans", "black jacket"]
    @Published var searchResults: [Match] = []
    @Published var viewMode: ViewMode = .grid
    
    // Filter properties
    @Published var minPrice: Double = 0
    @Published var maxPrice: Double = 500
    @Published var retailers: [String] = ["Fashion Store", "Style Hub", "Trendy Boutique", "Designer Outlet", "Vintage Collection"]
    @Published var selectedRetailers: [String] = []
    @Published var styles: [String] = ["Casual", "Formal", "Athletic", "Bohemian", "Vintage", "Minimalist"]
    @Published var selectedStyles: [String] = []
    @Published var activeFilters: [String] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadMockData()
    }
    
    private func loadMockData() {
        // Load mock designs
        recentDesigns = [
            Design(id: "1", name: "Summer Dress", thumbnail: "design-placeholder-1", createdAt: "April 10, 2025"),
            Design(id: "2", name: "Business Casual", thumbnail: "design-placeholder-2", createdAt: "April 5, 2025"),
            Design(id: "3", name: "Evening Gown", thumbnail: "design-placeholder-3", createdAt: "March 15, 2025")
        ]
    }
    
    func search(query: String) {
        guard !query.isEmpty else { return }
        
        // Add to recent searches if not already there
        if !recentSearches.contains(query) {
            recentSearches.insert(query, at: 0)
            if recentSearches.count > 5 {
                recentSearches.removeLast()
            }
        }
        
        // In a real implementation, this would call the API
        // For now, we'll use mock data
        searchResults = getMockSearchResults()
    }
    
    func searchByCategory(_ category: String) {
        // In a real implementation, this would call the API with the category
        // For now, we'll use mock data
        searchResults = getMockSearchResults()
    }
    
    func toggleViewMode() {
        viewMode = viewMode == .grid ? .list : .grid
    }
    
    func sortResults(by sortOption: SortOption) {
        switch sortOption {
        case .priceLowToHigh:
            searchResults.sort { $0.product.price < $1.product.price }
        case .priceHighToLow:
            searchResults.sort { $0.product.price > $1.product.price }
        case .matchScore:
            searchResults.sort { $0.matchScore > $1.matchScore }
        }
    }
    
    func toggleRetailerFilter(_ retailer: String) {
        if selectedRetailers.contains(retailer) {
            selectedRetailers.removeAll { $0 == retailer }
        } else {
            selectedRetailers.append(retailer)
        }
    }
    
    func toggleStyleFilter(_ style: String) {
        if selectedStyles.contains(style) {
            selectedStyles.removeAll { $0 == style }
        } else {
            selectedStyles.append(style)
        }
    }
    
    func resetFilters() {
        minPrice = 0
        maxPrice = 500
        selectedRetailers = []
        selectedStyles = []
    }
    
    func applyFilters() {
        activeFilters = []
        
        // Add price range filter
        if minPrice > 0 || maxPrice < 500 {
            activeFilters.append("$\(Int(minPrice)) - $\(Int(maxPrice))")
        }
        
        // Add retailer filters
        for retailer in selectedRetailers {
            activeFilters.append(retailer)
        }
        
        // Add style filters
        for style in selectedStyles {
            activeFilters.append(style)
        }
        
        // In a real implementation, this would filter the search results
        // For now, we'll just use the mock data
        searchResults = getMockSearchResults()
    }
    
    func removeFilter(_ filter: String) {
        activeFilters.removeAll { $0 == filter }
        
        // Remove from specific filter categories
        if filter.contains("$") {
            minPrice = 0
            maxPrice = 500
        } else if selectedRetailers.contains(filter) {
            selectedRetailers.removeAll { $0 == filter }
        } else if selectedStyles.contains(filter) {
            selectedStyles.removeAll { $0 == filter }
        }
        
        // Reapply remaining filters
        searchResults = getMockSearchResults()
    }
    
    func clearFilters() {
        activeFilters = []
        resetFilters()
        searchResults = []
    }
    
    private func getMockSearchResults() -> [Match] {
        return [
            Match(id: "1", designId: "1", product: Product(id: "p1", name: "Floral Summer Dress", price: 79.99, thumbnail: "product-placeholder-1", retailer: "Fashion Store"), matchScore: 92),
            Match(id: "2", designId: "1", product: Product(id: "p2", name: "Business Blazer", price: 129.99, thumbnail: "product-placeholder-2", retailer: "Style Hub"), matchScore: 87),
            Match(id: "3", designId: "1", product: Product(id: "p3", name: "Striped T-Shirt", price: 24.99, thumbnail: "product-placeholder-3", retailer: "Fashion Store"), matchScore: 78),
            Match(id: "4", designId: "1", product: Product(id: "p4", name: "Evening Gown", price: 199.99, thumbnail: "product-placeholder-4", retailer: "Designer Outlet"), matchScore: 65),
            Match(id: "5", designId: "1", product: Product(id: "p5", name: "Denim Jeans", price: 59.99, thumbnail: "product-placeholder-5", retailer: "Trendy Boutique"), matchScore: 82)
        ]
    }
}

enum ViewMode {
    case grid
    case list
}

enum SortOption {
    case priceLowToHigh
    case priceHighToLow
    case matchScore
}
