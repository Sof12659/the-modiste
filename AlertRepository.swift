import Foundation
import Combine

/// Repository for managing alert data
class AlertRepository {
    private let apiClient = APIClient.shared
    
    // Published properties for observing state changes
    @Published var alerts: [Alert] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadAlerts()
    }
    
    /// Load all alerts for the current user
    func loadAlerts() {
        isLoading = true
        
        apiClient.getAlerts()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            }, receiveValue: { [weak self] alerts in
                self?.alerts = alerts
            })
            .store(in: &cancellables)
    }
    
    /// Create a new alert
    func createAlert(designId: String, criteria: SearchCriteria) -> AnyPublisher<Alert, Error> {
        let alertRequest = AlertCreateRequest(
            designId: designId,
            criteria: criteria
        )
        
        return apiClient.createAlert(alert: alertRequest)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] alert in
                self?.alerts.append(alert)
            })
            .eraseToAnyPublisher()
    }
    
    /// Update an existing alert
    func updateAlert(id: String, status: String? = nil, criteria: SearchCriteria? = nil) -> AnyPublisher<Alert, Error> {
        let alertRequest = AlertUpdateRequest(
            status: status,
            criteria: criteria
        )
        
        return apiClient.updateAlert(id: id, alert: alertRequest)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] updatedAlert in
                if let index = self?.alerts.firstIndex(where: { $0.id == id }) {
                    self?.alerts[index] = updatedAlert
                }
            })
            .eraseToAnyPublisher()
    }
    
    /// Delete an alert
    func deleteAlert(id: String) -> AnyPublisher<Bool, Error> {
        return apiClient.deleteAlert(id: id)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.alerts.removeAll { $0.id == id }
            })
            .eraseToAnyPublisher()
    }
    
    /// Get active alerts
    func getActiveAlerts() -> [Alert] {
        return alerts.filter { $0.status == .active }
    }
    
    /// Get alerts for a specific design
    func getAlertsForDesign(designId: String) -> [Alert] {
        return alerts.filter { $0.designId == designId }
    }
}
