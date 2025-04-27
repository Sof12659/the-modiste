import Foundation
import Combine

class DesignerViewModel: ObservableObject {
    @Published var designElements: [DesignElement] = []
    @Published var availableGarments: [Garment] = []
    @Published var availableFabrics: [Fabric] = []
    @Published var fabricCategories: [String] = ["All", "Cotton", "Silk", "Wool", "Synthetic", "Denim", "Linen"]
    @Published var selectedFabricCategory: String = "All"
    @Published var recentColors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange]
    @Published var savedColors: [Color] = [.black, .white, .gray, .brown, .pink, .teal]
    
    private var undoStack: [[DesignElement]] = []
    private var redoStack: [[DesignElement]] = []
    
    init() {
        loadMockData()
    }
    
    private func loadMockData() {
        // Load mock garments
        availableGarments = [
            Garment(id: "g1", name: "T-Shirt", thumbnail: "tshirt-thumbnail", imageName: "tshirt-full"),
            Garment(id: "g2", name: "Dress", thumbnail: "dress-thumbnail", imageName: "dress-full"),
            Garment(id: "g3", name: "Pants", thumbnail: "pants-thumbnail", imageName: "pants-full"),
            Garment(id: "g4", name: "Skirt", thumbnail: "skirt-thumbnail", imageName: "skirt-full"),
            Garment(id: "g5", name: "Jacket", thumbnail: "jacket-thumbnail", imageName: "jacket-full"),
            Garment(id: "g6", name: "Blouse", thumbnail: "blouse-thumbnail", imageName: "blouse-full")
        ]
        
        // Load mock fabrics
        availableFabrics = [
            Fabric(id: "f1", name: "Cotton", category: "Cotton", thumbnail: "cotton-thumbnail"),
            Fabric(id: "f2", name: "Silk", category: "Silk", thumbnail: "silk-thumbnail"),
            Fabric(id: "f3", name: "Denim", category: "Denim", thumbnail: "denim-thumbnail"),
            Fabric(id: "f4", name: "Wool", category: "Wool", thumbnail: "wool-thumbnail"),
            Fabric(id: "f5", name: "Linen", category: "Linen", thumbnail: "linen-thumbnail"),
            Fabric(id: "f6", name: "Polyester", category: "Synthetic", thumbnail: "polyester-thumbnail")
        ]
    }
    
    func addGarment(_ garment: Garment) {
        saveToUndoStack()
        
        let newElement = DesignElement(
            id: UUID().uuidString,
            name: garment.name,
            type: .garment,
            imageName: garment.imageName,
            x: 200,
            y: 200,
            width: 200,
            height: 300,
            isVisible: true
        )
        
        designElements.append(newElement)
    }
    
    func moveElement(_ element: DesignElement, to position: CGPoint) {
        if let index = designElements.firstIndex(where: { $0.id == element.id }) {
            designElements[index].x = position.x
            designElements[index].y = position.y
        }
    }
    
    func removeElement(_ element: DesignElement) {
        saveToUndoStack()
        designElements.removeAll { $0.id == element.id }
    }
    
    func toggleElementVisibility(_ element: DesignElement) {
        if let index = designElements.firstIndex(where: { $0.id == element.id }) {
            designElements[index].isVisible.toggle()
        }
    }
    
    func selectColor(_ color: Color) {
        // In a real implementation, this would apply the selected color
        // to the currently selected design element
        
        // Add to recent colors if not already there
        if !recentColors.contains(color) {
            recentColors.insert(color, at: 0)
            if recentColors.count > 6 {
                recentColors.removeLast()
            }
        }
    }
    
    func selectFabricCategory(_ category: String) {
        selectedFabricCategory = category
    }
    
    func selectFabric(_ fabric: Fabric) {
        // In a real implementation, this would apply the selected fabric
        // to the currently selected design element
    }
    
    func saveDesign() {
        // In a real implementation, this would save the design to the backend
        print("Design saved")
    }
    
    func undoLastAction() {
        guard !undoStack.isEmpty else { return }
        
        // Save current state to redo stack
        redoStack.append(designElements)
        
        // Restore previous state
        designElements = undoStack.removeLast()
    }
    
    func redoLastAction() {
        guard !redoStack.isEmpty else { return }
        
        // Save current state to undo stack
        undoStack.append(designElements)
        
        // Restore next state
        designElements = redoStack.removeLast()
    }
    
    private func saveToUndoStack() {
        undoStack.append(designElements)
        redoStack.removeAll()
    }
}

// Design element types
enum DesignElementType {
    case garment
    case fabric
    case accessory
}

// Design tools
enum DesignTool {
    case select
    case garment
    case fabric
    case color
    case layers
}

// Design element model
struct DesignElement: Identifiable {
    let id: String
    let name: String
    let type: DesignElementType
    let imageName: String
    var x: CGFloat
    var y: CGFloat
    var width: CGFloat
    var height: CGFloat
    var isVisible: Bool
}

// Garment model
struct Garment: Identifiable {
    let id: String
    let name: String
    let thumbnail: String
    let imageName: String
}

// Fabric model
struct Fabric: Identifiable {
    let id: String
    let name: String
    let category: String
    let thumbnail: String
}
