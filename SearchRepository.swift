import Foundation
import Combine

/// Repository for managing search functionality
class SearchRepository {
    private let apiClient = APIClient.shared
    
    // Published properties for observing state changes
    @Published var searchResults: [Match] = []
    @Published var isSearching: Bool = false
    @Published var error: Error?
    
    // Search filters
    @Published var minPrice: Double = 0
    @Published var maxPrice: Double = 500
    @Published var selectedRetailers: [String] = []
    @Published var selectedStyles: [String] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    /// Search for products matching a design
    func searchProducts(designId: String) -> AnyPublisher<[Match], Error> {
        isSearching = true
        
        let criteria = SearchCriteria(
            priceRange: maxPrice,
            retailers: selectedRetailers.isEmpty ? nil : selectedRetailers,
            styles: selectedStyles.isEmpty ? nil : selectedStyles
        )
        
        return apiClient.searchProducts(designId: designId, criteria: criteria)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCompletion: { [weak self] completion in
                self?.isSearching = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            }, receiveValue: { [weak self] matches in
                self?.searchResults = matches
            })
            .eraseToAnyPublisher()
    }
    
    /// Analyze a design to extract attributes
    func analyzeDesign(imageUrl: String, designId: String? = nil) -> AnyPublisher<DesignAttributes, Error> {
        return apiClient.analyzeDesign(imageUrl: imageUrl, designId: designId)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// Filter search results by price range
    func filterByPriceRange(min: Double, max: Double) {
        minPrice = min
        maxPrice = max
    }
    
    /// Toggle retailer filter
    func toggleRetailerFilter(_ retailer: String) {
        if selectedRetailers.contains(retailer) {
            selectedRetailers.removeAll { $0 == retailer }
        } else {
            selectedRetailers.append(retailer)
        }
    }
    
    /// Toggle style filter
    func toggleStyleFilter(_ style: String) {
        if selectedStyles.contains(style) {
            selectedStyles.removeAll { $0 == style }
        } else {
            selectedStyles.append(style)
        }
    }
    
    /// Reset all filters
    func resetFilters() {
        minPrice = 0
        maxPrice = 500
        selectedRetailers = []
        selectedStyles = []
    }
    
    /// Sort search results by various criteria
    func sortResults(by sortOption: SearchSortOption) -> [Match] {
        switch sortOption {
        case .priceLowToHigh:
            return searchResults.sorted { $0.product.price < $1.product.price }
        case .priceHighToLow:
            return searchResults.sorted { $0.product.price > $1.product.price }
        case .matchScore:
            return searchResults.sorted { $0.matchScore > $1.matchScore }
        }
    }
    
    /// Get seamstresses near a location
    func getSeamstresses(location: String? = nil, specialty: String? = nil) -> AnyPublisher<[Seamstress], Error> {
        return apiClient.getSeamstresses(location: location, specialty: specialty)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// Contact a seamstress about a design
    func contactSeamstress(id: String, designId: String, message: String) -> AnyPublisher<ContactResponse, Error> {
        return apiClient.contactSeamstress(id: id, designId: designId, message: message)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

/// Search sort options
enum SearchSortOption {
    case priceLowToHigh
    case priceHighToLow
    case matchScore
}
