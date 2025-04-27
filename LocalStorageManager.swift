import Foundation
import Combine

/// Local storage manager for offline data persistence
class LocalStorageManager {
    // Shared instance (singleton)
    static let shared = LocalStorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let fileManager = FileManager.default
    
    private init() {}
    
    // MARK: - User Defaults Storage
    
    /// Save object to UserDefaults
    func saveObject<T: Encodable>(_ object: T, forKey key: String) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(object)
            userDefaults.set(data, forKey: key)
        } catch {
            print("Error saving object to UserDefaults: \(error)")
        }
    }
    
    /// Load object from UserDefaults
    func loadObject<T: Decodable>(forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Error loading object from UserDefaults: \(error)")
            return nil
        }
    }
    
    // MARK: - File Storage
    
    /// Save data to file
    func saveToFile(data: Data, fileName: String, directory: FileDirectory) -> Bool {
        guard let url = getFileURL(fileName: fileName, directory: directory) else {
            return false
        }
        
        do {
            try data.write(to: url)
            return true
        } catch {
            print("Error saving data to file: \(error)")
            return false
        }
    }
    
    /// Load data from file
    func loadFromFile(fileName: String, directory: FileDirectory) -> Data? {
        guard let url = getFileURL(fileName: fileName, directory: directory) else {
            return nil
        }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Error loading data from file: \(error)")
            return nil
        }
    }
    
    /// Delete file
    func deleteFile(fileName: String, directory: FileDirectory) -> Bool {
        guard let url = getFileURL(fileName: fileName, directory: directory) else {
            return false
        }
        
        do {
            try fileManager.removeItem(at: url)
            return true
        } catch {
            print("Error deleting file: \(error)")
            return false
        }
    }
    
    /// Get URL for file
    private func getFileURL(fileName: String, directory: FileDirectory) -> URL? {
        do {
            let directoryURL: URL
            
            switch directory {
            case .documents:
                directoryURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            case .cache:
                directoryURL = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            case .temporary:
                directoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
            }
            
            return directoryURL.appendingPathComponent(fileName)
        } catch {
            print("Error getting file URL: \(error)")
            return nil
        }
    }
    
    // MARK: - Cache Management
    
    /// Cache designs for offline access
    func cacheDesigns(_ designs: [Design]) {
        saveObject(designs, forKey: "cachedDesigns")
    }
    
    /// Get cached designs
    func getCachedDesigns() -> [Design]? {
        return loadObject(forKey: "cachedDesigns")
    }
    
    /// Cache alerts for offline access
    func cacheAlerts(_ alerts: [Alert]) {
        saveObject(alerts, forKey: "cachedAlerts")
    }
    
    /// Get cached alerts
    func getCachedAlerts() -> [Alert]? {
        return loadObject(forKey: "cachedAlerts")
    }
    
    /// Clear all cached data
    func clearAllCachedData() {
        let keys = ["cachedDesigns", "cachedAlerts", "authToken"]
        keys.forEach { userDefaults.removeObject(forKey: $0) }
        
        // Clear temporary files
        do {
            let tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
            let fileURLs = try fileManager.contentsOfDirectory(at: tempDirectory, includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                try fileManager.removeItem(at: fileURL)
            }
        } catch {
            print("Error clearing temporary files: \(error)")
        }
    }
}

/// File directory types
enum FileDirectory {
    case documents
    case cache
    case temporary
}
