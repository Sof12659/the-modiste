import Foundation
import Combine

class GalleryViewModel: ObservableObject {
    @Published var designs: [Design] = []
    @Published var filteredDesigns: [Design] = []
    @Published var viewMode: ViewMode = .grid
    @Published var currentFilter: String = "All"
    @Published var filterOptions: [String] = ["All", "Recent", "Favorites", "Dresses", "Tops", "Bottoms"]
    @Published var dateFilter: DateFilter = .allTime
    @Published var showFavoritesOnly: Bool = false
    @Published var sortOption: SortOption = .newest
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadMockData()
        filteredDesigns = designs
    }
    
    private func loadMockData() {
        // Load mock designs
        designs = [
            Design(id: "1", name: "Summer Dress", thumbnail: "design-placeholder-1", createdAt: "April 10, 2025", isFavorite: true),
            Design(id: "2", name: "Business Casual", thumbnail: "design-placeholder-2", createdAt: "April 5, 2025"),
            Design(id: "3", name: "Evening Gown", thumbnail: "design-placeholder-3", createdAt: "March 15, 2025", isFavorite: true),
            Design(id: "4", name: "Casual Jeans", thumbnail: "design-placeholder-4", createdAt: "March 10, 2025"),
            Design(id: "5", name: "Winter Coat", thumbnail: "design-placeholder-5", createdAt: "February 20, 2025"),
            Design(id: "6", name: "Workout Outfit", thumbnail: "design-placeholder-6", createdAt: "February 5, 2025", isFavorite: true)
        ]
    }
    
    func toggleViewMode() {
        viewMode = viewMode == .grid ? .list : .grid
    }
    
    func setFilter(_ filter: String) {
        currentFilter = filter
        applyFilters()
    }
    
    func filterDesigns(searchText: String) {
        if searchText.isEmpty {
            applyFilters()
        } else {
            filteredDesigns = designs.filter { design in
                design.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func toggleFavorite(_ design: Design) {
        if let index = designs.firstIndex(where: { $0.id == design.id }) {
            designs[index].isFavorite.toggle()
            
            // Update filtered designs as well
            if let filteredIndex = filteredDesigns.firstIndex(where: { $0.id == design.id }) {
                filteredDesigns[filteredIndex].isFavorite.toggle()
            }
        }
    }
    
    func setSortOption(_ option: SortOption) {
        sortOption = option
        sortDesigns()
    }
    
    func setDateFilter(_ filter: String) {
        switch filter {
        case "Last 7 days":
            dateFilter = .lastWeek
        case "Last 30 days":
            dateFilter = .lastMonth
        case "Last 90 days":
            dateFilter = .last3Months
        default:
            dateFilter = .allTime
        }
    }
    
    func resetFilters() {
        currentFilter = "All"
        dateFilter = .allTime
        showFavoritesOnly = false
    }
    
    func applyFilters() {
        // Start with all designs
        var filtered = designs
        
        // Apply category filter
        if currentFilter != "All" {
            if currentFilter == "Favorites" {
                filtered = filtered.filter { $0.isFavorite }
            } else if currentFilter == "Recent" {
                // In a real implementation, this would filter by date
                filtered = Array(filtered.prefix(3))
            } else {
                // Filter by category (e.g., Dresses, Tops, etc.)
                // In a real implementation, designs would have a category property
                filtered = filtered.filter { $0.name.lowercased().contains(currentFilter.lowercased()) }
            }
        }
        
        // Apply date filter
        // In a real implementation, this would use actual dates
        switch dateFilter {
        case .lastWeek:
            filtered = filtered.filter { $0.createdAt.contains("April") }
        case .lastMonth:
            filtered = filtered.filter { $0.createdAt.contains("April") || $0.createdAt.contains("March") }
        case .last3Months:
            filtered = filtered.filter { !$0.createdAt.contains("January") }
        case .allTime:
            // No filtering needed
            break
        }
        
        // Apply favorites filter
        if showFavoritesOnly {
            filtered = filtered.filter { $0.isFavorite }
        }
        
        filteredDesigns = filtered
        sortDesigns()
    }
    
    private func sortDesigns() {
        switch sortOption {
        case .newest:
            // In a real implementation, this would sort by actual dates
            filteredDesigns.sort { $0.createdAt > $1.createdAt }
        case .oldest:
            filteredDesigns.sort { $0.createdAt < $1.createdAt }
        case .nameAscending:
            filteredDesigns.sort { $0.name < $1.name }
        case .nameDescending:
            filteredDesigns.sort { $0.name > $1.name }
        }
    }
}

enum DateFilter {
    case lastWeek
    case lastMonth
    case last3Months
    case allTime
}

enum SortOption {
    case newest
    case oldest
    case nameAscending
    case nameDescending
}
