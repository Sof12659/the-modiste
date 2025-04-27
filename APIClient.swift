import Foundation
import Combine

/// API client for communicating with the Sew Real backend
class APIClient {
    static let shared = APIClient()
    
    private let baseURL = "https://api.sewreal.com"
    private var authToken: String?
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // Load auth token from UserDefaults if available
        authToken = UserDefaults.standard.string(forKey: "authToken")
    }
    
    // MARK: - Authentication
    
    func login(email: String, password: String) -> AnyPublisher<User, Error> {
        let endpoint = "/api/users/login"
        let body: [String: Any] = ["email": email, "password": password]
        
        return request(endpoint: endpoint, method: "POST", body: body)
            .tryMap { data, response -> AuthResponse in
                try JSONDecoder().decode(AuthResponse.self, from: data)
            }
            .handleEvents(receiveOutput: { [weak self] response in
                self?.authToken = response.token
                UserDefaults.standard.set(response.token, forKey: "authToken")
            })
            .map { $0.user }
            .eraseToAnyPublisher()
    }
    
    func register(name: String, email: String, password: String) -> AnyPublisher<User, Error> {
        let endpoint = "/api/users/register"
        let body: [String: Any] = ["name": name, "email": email, "password": password]
        
        return request(endpoint: endpoint, method: "POST", body: body)
            .tryMap { data, response -> AuthResponse in
                try JSONDecoder().decode(AuthResponse.self, from: data)
            }
            .handleEvents(receiveOutput: { [weak self] response in
                self?.authToken = response.token
                UserDefaults.standard.set(response.token, forKey: "authToken")
            })
            .map { $0.user }
            .eraseToAnyPublisher()
    }
    
    func logout() {
        authToken = nil
        UserDefaults.standard.removeObject(forKey: "authToken")
    }
    
    // MARK: - Designs
    
    func getDesigns() -> AnyPublisher<[Design], Error> {
        let endpoint = "/api/designs"
        
        return authenticatedRequest(endpoint: endpoint, method: "GET")
            .tryMap { data, response -> [Design] in
                try JSONDecoder().decode([Design].self, from: data)
            }
            .eraseToAnyPublisher()
    }
    
    func getDesign(id: String) -> AnyPublisher<Design, Error> {
        let endpoint = "/api/designs/\(id)"
        
        return authenticatedRequest(endpoint: endpoint, method: "GET")
            .tryMap { data, response -> Design in
                try JSONDecoder().decode(Design.self, from: data)
            }
            .eraseToAnyPublisher()
    }
    
    func createDesign(design: DesignCreateRequest) -> AnyPublisher<Design, Error> {
        let endpoint = "/api/designs"
        
        return authenticatedRequest(endpoint: endpoint, method: "POST", body: design)
            .tryMap { data, response -> Design in
                try JSONDecoder().decode(Design.self, from: data)
            }
            .eraseToAnyPublisher()
    }
    
    func updateDesign(id: String, design: DesignUpdateRequest) -> AnyPublisher<Design, Error> {
        let endpoint = "/api/designs/\(id)"
        
        return authenticatedRequest(endpoint: endpoint, method: "PUT", body: design)
            .tryMap { data, response -> Design in
                try JSONDecoder().decode(Design.self, from: data)
            }
            .eraseToAnyPublisher()
    }
    
    func deleteDesign(id: String) -> AnyPublisher<Bool, Error> {
        let endpoint = "/api/designs/\(id)"
        
        return authenticatedRequest(endpoint: endpoint, method: "DELETE")
            .map { _, _ in true }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Alerts
    
    func getAlerts() -> AnyPublisher<[Alert], Error> {
        let endpoint = "/api/alerts"
        
        return authenticatedRequest(endpoint: endpoint, method: "GET")
            .tryMap { data, response -> [Alert] in
                try JSONDecoder().decode([Alert].self, from: data)
            }
            .eraseToAnyPublisher()
    }
    
    func createAlert(alert: AlertCreateRequest) -> AnyPublisher<Alert, Error> {
        let endpoint = "/api/alerts"
        
        return authenticatedRequest(endpoint: endpoint, method: "POST", body: alert)
            .tryMap { data, response -> Alert in
                try JSONDecoder().decode(Alert.self, from: data)
            }
            .eraseToAnyPublisher()
    }
    
    func updateAlert(id: String, alert: AlertUpdateRequest) -> AnyPublisher<Alert, Error> {
        let endpoint = "/api/alerts/\(id)"
        
        return authenticatedRequest(endpoint: endpoint, method: "PUT", body: alert)
            .tryMap { data, response -> Alert in
                try JSONDecoder().decode(Alert.self, from: data)
            }
            .eraseToAnyPublisher()
    }
    
    func deleteAlert(id: String) -> AnyPublisher<Bool, Error> {
        let endpoint = "/api/alerts/\(id)"
        
        return authenticatedRequest(endpoint: endpoint, method: "DELETE")
            .map { _, _ in true }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Search
    
    func searchProducts(designId: String, criteria: SearchCriteria) -> AnyPublisher<[Match], Error> {
        let endpoint = "/api/ai/find-matches"
        let body: [String: Any] = [
            "designId": designId,
            "criteria": criteria
        ]
        
        return authenticatedRequest(endpoint: endpoint, method: "POST", body: body)
            .tryMap { data, response -> [Match] in
                try JSONDecoder().decode([Match].self, from: data)
            }
            .eraseToAnyPublisher()
    }
    
    func analyzeDesign(imageUrl: String, designId: String? = nil) -> AnyPublisher<DesignAttributes, Error> {
        let endpoint = "/api/ai/analyze-design"
        var body: [String: Any] = ["imageUrl": imageUrl]
        if let designId = designId {
            body["designId"] = designId
        }
        
        return authenticatedRequest(endpoint: endpoint, method: "POST", body: body)
            .tryMap { data, response -> DesignAttributes in
                try JSONDecoder().decode(DesignAttributes.self, from: data)
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Seamstresses
    
    func getSeamstresses(location: String? = nil, specialty: String? = nil) -> AnyPublisher<[Seamstress], Error> {
        var endpoint = "/api/seamstresses"
        
        var queryItems: [URLQueryItem] = []
        if let location = location {
            queryItems.append(URLQueryItem(name: "location", value: location))
        }
        if let specialty = specialty {
            queryItems.append(URLQueryItem(name: "specialty", value: specialty))
        }
        
        if !queryItems.isEmpty {
            var urlComponents = URLComponents(string: endpoint)
            urlComponents?.queryItems = queryItems
            endpoint = urlComponents?.string ?? endpoint
        }
        
        return authenticatedRequest(endpoint: endpoint, method: "GET")
            .tryMap { data, response -> [Seamstress] in
                try JSONDecoder().decode([Seamstress].self, from: data)
            }
            .eraseToAnyPublisher()
    }
    
    func contactSeamstress(id: String, designId: String, message: String) -> AnyPublisher<ContactResponse, Error> {
        let endpoint = "/api/seamstresses/contact/\(id)"
        let body: [String: Any] = [
            "designId": designId,
            "message": message
        ]
        
        return authenticatedRequest(endpoint: endpoint, method: "POST", body: body)
            .tryMap { data, response -> ContactResponse in
                try JSONDecoder().decode(ContactResponse.self, from: data)
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Helper Methods
    
    private func request(endpoint: String, method: String, body: Any? = nil) -> AnyPublisher<(Data, URLResponse), Error> {
        guard let url = URL(string: baseURL + endpoint) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                return Fail(error: APIError.encodingFailed).eraseToAnyPublisher()
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    private func authenticatedRequest(endpoint: String, method: String, body: Any? = nil) -> AnyPublisher<(Data, URLResponse), Error> {
        guard let token = authToken else {
            return Fail(error: APIError.unauthorized).eraseToAnyPublisher()
        }
        
        guard let url = URL(string: baseURL + endpoint) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        if let body = body {
            do {
                if let encodable = body as? Encodable {
                    let encoder = JSONEncoder()
                    request.httpBody = try encoder.encode(encodable)
                } else {
                    request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
                }
            } catch {
                return Fail(error: APIError.encodingFailed).eraseToAnyPublisher()
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                if httpResponse.statusCode == 401 {
                    throw APIError.unauthorized
                }
                
                if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                    throw APIError.serverError(statusCode: httpResponse.statusCode)
                }
                
                return (data, response)
            }
            .mapError { error in
                if let apiError = error as? APIError {
                    return apiError
                }
                return APIError.networkError(error)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - API Models

struct AuthResponse: Codable {
    let token: String
    let user: User
}

struct DesignCreateRequest: Encodable {
    let name: String
    let designData: String // JSON string of design elements
    let thumbnail: String // Base64 encoded image
}

struct DesignUpdateRequest: Encodable {
    let name: String?
    let designData: String? // JSON string of design elements
    let thumbnail: String? // Base64 encoded image
    let isFavorite: Bool?
}

struct AlertCreateRequest: Encodable {
    let designId: String
    let criteria: SearchCriteria
}

struct AlertUpdateRequest: Encodable {
    let status: String?
    let criteria: SearchCriteria?
}

struct SearchCriteria: Encodable {
    let priceRange: Double?
    let retailers: [String]?
    let styles: [String]?
}

struct DesignAttributes: Codable {
    let colors: [ColorInfo]
    let colorPalette: ColorPalette
    let pattern: String
    let style: String
    let garmentType: String
}

struct ColorInfo: Codable {
    let rgb: [Int]
    let hex: String
    let hsl: [Int]
}

struct ColorPalette: Codable {
    let temperature: String
    let brightness: String
    let saturation: String
    let harmony: String
    let primaryColor: String
}

struct ContactResponse: Codable {
    let message: String
    let seamstress: SeamstressInfo
}

struct SeamstressInfo: Codable {
    let name: String
    let email: String
}

// MARK: - API Errors

enum APIError: Error {
    case invalidURL
    case encodingFailed
    case invalidResponse
    case unauthorized
    case serverError(statusCode: Int)
    case networkError(Error)
}
