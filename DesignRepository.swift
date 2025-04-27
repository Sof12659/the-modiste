import Foundation
import Combine

/// Repository for managing design data
class DesignRepository {
    private let apiClient = APIClient.shared
    
    // Published properties for observing state changes
    @Published var designs: [Design] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadDesigns()
    }
    
    /// Load all designs for the current user
    func loadDesigns() {
        isLoading = true
        
        apiClient.getDesigns()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            }, receiveValue: { [weak self] designs in
                self?.designs = designs
            })
            .store(in: &cancellables)
    }
    
    /// Get a specific design by ID
    func getDesign(id: String) -> AnyPublisher<Design, Error> {
        return apiClient.getDesign(id: id)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// Create a new design
    func createDesign(name: String, designData: String, thumbnail: String) -> AnyPublisher<Design, Error> {
        let designRequest = DesignCreateRequest(
            name: name,
            designData: designData,
            thumbnail: thumbnail
        )
        
        return apiClient.createDesign(design: designRequest)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] design in
                self?.designs.append(design)
            })
            .eraseToAnyPublisher()
    }
    
    /// Update an existing design
    func updateDesign(id: String, name: String? = nil, designData: String? = nil, thumbnail: String? = nil, isFavorite: Bool? = nil) -> AnyPublisher<Design, Error> {
        let designRequest = DesignUpdateRequest(
            name: name,
            designData: designData,
            thumbnail: thumbnail,
            isFavorite: isFavorite
        )
        
        return apiClient.updateDesign(id: id, design: designRequest)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] updatedDesign in
                if let index = self?.designs.firstIndex(where: { $0.id == id }) {
                    self?.designs[index] = updatedDesign
                }
            })
            .eraseToAnyPublisher()
    }
    
    /// Toggle favorite status for a design
    func toggleFavorite(design: Design) -> AnyPublisher<Design, Error> {
        return updateDesign(id: design.id, isFavorite: !design.isFavorite)
    }
    
    /// Delete a design
    func deleteDesign(id: String) -> AnyPublisher<Bool, Error> {
        return apiClient.deleteDesign(id: id)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.designs.removeAll { $0.id == id }
            })
            .eraseToAnyPublisher()
    }
    
    /// Filter designs by search text
    func filterDesigns(searchText: String) -> [Design] {
        if searchText.isEmpty {
            return designs
        } else {
            return designs.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    /// Filter designs by category
    func filterDesigns(category: String) -> [Design] {
        if category == "All" {
            return designs
        } else if category == "Favorites" {
            return designs.filter { $0.isFavorite }
        } else {
            // In a real implementation, designs would have a category property
            return designs.filter { $0.name.lowercased().contains(category.lowercased()) }
        }
    }
    
    /// Sort designs by various criteria
    func sortDesigns(by sortOption: SortOption) -> [Design] {
        switch sortOption {
        case .newest:
            return designs.sorted { $0.createdAt > $1.createdAt }
        case .oldest:
            return designs.sorted { $0.createdAt < $1.createdAt }
        case .nameAscending:
            return designs.sorted { $0.name < $1.name }
        case .nameDescending:
            return designs.sorted { $0.name > $1.name }
        }
    }
}
