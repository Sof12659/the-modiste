import SwiftUI

struct DesignCard: View {
    let design: Design
    
    var body: some View {
        NavigationLink(destination: Text("Design Detail View")) {
            VStack(alignment: .leading) {
                ZStack(alignment: .topTrailing) {
                    // Design image
                    Image(design.thumbnail)
                        .resizable()
                        .aspectRatio(contentMode: .cover)
                        .frame(height: 160)
                        .cornerRadius(12)
                    
                    // Favorite button
                    Button(action: {
                        // Toggle favorite
                    }) {
                        Image(systemName: design.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(design.isFavorite ? .red : .white)
                            .padding(8)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .padding(8)
                }
                
                Text(design.name)
                    .font(.headline)
                    .foregroundColor(Color("DarkText"))
                    .lineLimit(1)
                
                Text(design.createdAt)
                    .font(.caption)
                    .foregroundColor(Color("LightText"))
            }
            .background(Color("Background"))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

struct AlertCard: View {
    let alert: Alert
    
    var body: some View {
        HStack(spacing: 16) {
            // Design thumbnail
            Image(alert.designThumbnail)
                .resizable()
                .aspectRatio(contentMode: .cover)
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            
            // Alert info
            VStack(alignment: .leading, spacing: 4) {
                Text(alert.designName)
                    .font(.headline)
                    .foregroundColor(Color("DarkText"))
                
                Text(alert.createdAt)
                    .font(.caption)
                    .foregroundColor(Color("LightText"))
                
                HStack {
                    statusBadge
                    Spacer()
                }
            }
            
            Spacer()
            
            // Actions
            Button(action: {
                // View alert details
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(Color("LightText"))
            }
        }
        .padding(16)
        .background(Color("Background"))
        .cornerRadius(12)
        .overlay(
            Rectangle()
                .frame(width: 4)
                .foregroundColor(statusColor)
                .cornerRadius(4, corners: [.topLeft, .bottomLeft]),
            alignment: .leading
        )
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var statusBadge: some View {
        Text(statusText)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor)
            .cornerRadius(10)
    }
    
    private var statusText: String {
        switch alert.status {
        case .active:
            return "Active"
        case .paused:
            return "Paused"
        case .expired:
            return "Expired"
        case .matchesFound:
            return "Matches Found"
        }
    }
    
    private var statusColor: Color {
        switch alert.status {
        case .active:
            return Color("PrimaryBlue")
        case .paused:
            return Color("LightText")
        case .expired:
            return Color("LightText")
        case .matchesFound:
            return Color("SecondaryPurple")
        }
    }
}

struct ProductCard: View {
    let product: Product
    let matchScore: Int
    
    var body: some View {
        NavigationLink(destination: Text("Product Detail View")) {
            VStack(alignment: .leading) {
                ZStack(alignment: .topLeading) {
                    // Product image
                    Image(product.thumbnail)
                        .resizable()
                        .aspectRatio(contentMode: .cover)
                        .frame(height: 160)
                        .cornerRadius(12)
                    
                    // Match score badge
                    ZStack {
                        Circle()
                            .fill(Color("PrimaryBlue"))
                            .frame(width: 36, height: 36)
                        
                        Text("\(matchScore)%")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(8)
                }
                
                Text(product.name)
                    .font(.headline)
                    .foregroundColor(Color("DarkText"))
                    .lineLimit(1)
                
                HStack {
                    Text("$\(String(format: "%.2f", product.price))")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("DarkText"))
                    
                    Spacer()
                    
                    Text(product.retailer)
                        .font(.caption)
                        .foregroundColor(Color("LightText"))
                }
            }
            .background(Color("Background"))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

// Extension to apply corner radius to specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
