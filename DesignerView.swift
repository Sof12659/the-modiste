import SwiftUI

struct DesignerView: View {
    @StateObject private var viewModel = DesignerViewModel()
    @State private var showingToolPanel = false
    @State private var selectedTool: DesignTool = .select
    @State private var showingColorPicker = false
    @State private var showingFabricPicker = false
    @State private var showingSaveOptions = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Design canvas
                designCanvas
                
                // Bottom toolbar
                VStack {
                    Spacer()
                    toolBar
                }
                
                // Tool panels that slide up from bottom
                if showingToolPanel {
                    toolPanel
                }
                
                // Color picker panel
                if showingColorPicker {
                    colorPickerPanel
                }
                
                // Fabric picker panel
                if showingFabricPicker {
                    fabricPickerPanel
                }
            }
            .navigationTitle("Designer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSaveOptions = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            .sheet(isPresented: $showingSaveOptions) {
                saveOptionsView
            }
        }
    }
    
    private var designCanvas: some View {
        ZStack {
            // Canvas background
            Rectangle()
                .fill(Color.white)
                .border(Color("BorderColor"), width: 1)
                .padding()
            
            // Design elements would be rendered here
            // In a real implementation, this would use a canvas library
            // like PencilKit or a custom drawing implementation
            
            if viewModel.designElements.isEmpty {
                // Empty state
                VStack(spacing: 16) {
                    Image(systemName: "tshirt")
                        .font(.system(size: 64))
                        .foregroundColor(Color("LightText"))
                    
                    Text("Start designing your outfit")
                        .font(.headline)
                        .foregroundColor(Color("LightText"))
                    
                    Text("Use the tools below to add garments, fabrics, and colors")
                        .font(.subheadline)
                        .foregroundColor(Color("LightText"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            } else {
                // Render design elements
                ForEach(viewModel.designElements) { element in
                    designElementView(element)
                }
            }
        }
    }
    
    private func designElementView(_ element: DesignElement) -> some View {
        // This is a simplified implementation
        // In a real app, this would handle different element types
        // and support gestures for moving, resizing, etc.
        Image(element.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: element.width, height: element.height)
            .position(x: element.x, y: element.y)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        viewModel.moveElement(element, to: value.location)
                    }
            )
    }
    
    private var toolBar: some View {
        HStack(spacing: 20) {
            toolButton(tool: .garment, icon: "tshirt")
            toolButton(tool: .fabric, icon: "square.on.circle")
            toolButton(tool: .color, icon: "paintpalette")
            toolButton(tool: .layers, icon: "square.3.stack.3d")
            
            Spacer()
            
            Button(action: {
                viewModel.undoLastAction()
            }) {
                Image(systemName: "arrow.uturn.backward")
                    .font(.system(size: 24))
                    .foregroundColor(Color("DarkText"))
            }
            
            Button(action: {
                viewModel.redoLastAction()
            }) {
                Image(systemName: "arrow.uturn.forward")
                    .font(.system(size: 24))
                    .foregroundColor(Color("DarkText"))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("Background"))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        )
    }
    
    private func toolButton(tool: DesignTool, icon: String) -> some View {
        Button(action: {
            selectedTool = tool
            showingToolPanel = true
            
            if tool == .color {
                showingColorPicker = true
                showingFabricPicker = false
            } else if tool == .fabric {
                showingFabricPicker = true
                showingColorPicker = false
            } else {
                showingColorPicker = false
                showingFabricPicker = false
            }
        }) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(selectedTool == tool ? Color("PrimaryBlue") : Color("DarkText"))
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(selectedTool == tool ? Color("PrimaryBlue").opacity(0.2) : Color.clear)
                )
        }
    }
    
    private var toolPanel: some View {
        VStack {
            // Panel header
            HStack {
                Text(panelTitle)
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    showingToolPanel = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(Color("DarkText"))
                }
            }
            .padding()
            
            // Panel content
            ScrollView {
                panelContent
            }
        }
        .frame(height: 300)
        .background(Color("Background"))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        .transition(.move(edge: .bottom))
        .animation(.spring(), value: showingToolPanel)
    }
    
    private var panelTitle: String {
        switch selectedTool {
        case .select:
            return "Select Tool"
        case .garment:
            return "Garments"
        case .fabric:
            return "Fabrics"
        case .color:
            return "Colors"
        case .layers:
            return "Layers"
        }
    }
    
    private var panelContent: some View {
        switch selectedTool {
        case .select:
            return AnyView(Text("Select an element to edit"))
        case .garment:
            return AnyView(garmentGrid)
        case .fabric:
            return AnyView(Text("Fabric options would appear here"))
        case .color:
            return AnyView(Text("Color options would appear here"))
        case .layers:
            return AnyView(layersList)
        }
    }
    
    private var garmentGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
            ForEach(viewModel.availableGarments) { garment in
                Button(action: {
                    viewModel.addGarment(garment)
                }) {
                    VStack {
                        Image(garment.thumbnail)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                            .cornerRadius(8)
                        
                        Text(garment.name)
                            .font(.caption)
                            .foregroundColor(Color("DarkText"))
                    }
                    .padding(8)
                    .background(Color("LightBackground"))
                    .cornerRadius(12)
                }
            }
        }
        .padding()
    }
    
    private var layersList: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(viewModel.designElements) { element in
                HStack {
                    Image(systemName: "square")
                        .foregroundColor(Color("DarkText"))
                    
                    Text(element.name)
                        .foregroundColor(Color("DarkText"))
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.toggleElementVisibility(element)
                    }) {
                        Image(systemName: element.isVisible ? "eye" : "eye.slash")
                            .foregroundColor(Color("DarkText"))
                    }
                    
                    Button(action: {
                        viewModel.removeElement(element)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(Color("ErrorRed"))
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color("LightBackground"))
                .cornerRadius(8)
            }
        }
        .padding()
    }
    
    private var colorPickerPanel: some View {
        VStack {
            // Color wheel would go here
            // In a real implementation, this would use ColorPicker or a custom color wheel
            
            Text("Color picker would appear here")
                .padding()
            
            // Recent colors
            VStack(alignment: .leading) {
                Text("Recent Colors")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.recentColors, id: \.self) { color in
                            colorSwatch(color: color)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // Saved colors
            VStack(alignment: .leading) {
                Text("Saved Colors")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.savedColors, id: \.self) { color in
                            colorSwatch(color: color)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .frame(height: 300)
        .background(Color("Background"))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        .transition(.move(edge: .bottom))
        .animation(.spring(), value: showingColorPicker)
    }
    
    private func colorSwatch(color: Color) -> some View {
        Button(action: {
            viewModel.selectColor(color)
        }) {
            Circle()
                .fill(color)
                .frame(width: 40, height: 40)
                .overlay(
                    Circle()
                        .stroke(Color("BorderColor"), lineWidth: 1)
                )
        }
    }
    
    private var fabricPickerPanel: some View {
        VStack {
            // Fabric categories
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.fabricCategories, id: \.self) { category in
                        Button(action: {
                            viewModel.selectFabricCategory(category)
                        }) {
                            Text(category)
                                .font(.subheadline)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(viewModel.selectedFabricCategory == category ? Color("PrimaryBlue") : Color("LightBackground"))
                                )
                                .foregroundColor(viewModel.selectedFabricCategory == category ? .white : Color("DarkText"))
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Fabric grid
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                    ForEach(viewModel.availableFabrics.filter { viewModel.selectedFabricCategory == "All" || $0.category == viewModel.selectedFabricCategory }) { fabric in
                        Button(action: {
                            viewModel.selectFabric(fabric)
                        }) {
                            VStack {
                                Image(fabric.thumbnail)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 80)
                                    .cornerRadius(8)
                                
                                Text(fabric.name)
                                    .font(.caption)
                                    .foregroundColor(Color("DarkText"))
                            }
                            .padding(8)
                            .background(Color("LightBackground"))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
        }
        .frame(height: 300)
        .background(Color("Background"))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        .transition(.move(edge: .bottom))
        .animation(.spring(), value: showingFabricPicker)
    }
    
    private var saveOptionsView: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Save design
                Button(action: {
                    viewModel.saveDesign()
                    showingSaveOptions = false
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                            .font(.title2)
                        
                        Text("Save to Gallery")
                            .font(.headline)
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color("LightBackground"))
                    .cornerRadius(12)
                }
                
                // Search for matches
                Button(action: {
                    // Navigate to search results
                    showingSaveOptions = false
                }) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                        
                        Text("Search for Matches")
                            .font(.headline)
                        
                        Spacer()
         
(Content truncated due to size limit. Use line ranges to read in chunks)