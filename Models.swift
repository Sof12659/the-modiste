import Foundation

struct Design: Identifiable {
    let id: String
    let name: String
    let thumbnail: String
    let createdAt: String
    var isFavorite: Bool = false
    
    // In a real implementation, this would include more properties like:
    // - designData (the actual design content)
    // - tags
    // - views (different angles)
    // - updatedAt
}

struct Alert: Identifiable {
    let id: String
    let designId: String
    let designName: String
    let designThumbnail: String
    let status: AlertStatus
    let createdAt: String
    
    // In a real implementation, this would include more properties like:
    // - criteria
    // - expiresAt
    // - priority
    // - notificationPreferences
}

enum AlertStatus {
    case active
    case paused
    case expired
    case matchesFound
}

struct Product: Identifiable {
    let id: String
    let name: String
    let price: Double
    let thumbnail: String
    let retailer: String
    
    // In a real implementation, this would include more properties like:
    // - description
    // - images (array of image URLs)
    // - url (link to product on retailer site)
    // - attributes (style, color, pattern, material, size)
}

struct Match: Identifiable {
    let id: String
    let designId: String
    let product: Product
    let matchScore: Int
    
    // In a real implementation, this would include more properties like:
    // - matchQuality (detailed scores for color, pattern, style)
    // - status (new, viewed, saved, dismissed)
    // - createdAt
}
