import SwiftUI

struct GalleryView: View {
    @StateObject private var viewModel = GalleryViewModel()
    @State private var searchText = ""
    @State private var showingFilterOptions = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search and filter bar
                searchAndFilterBar
                
                // Gallery content
                if viewModel.filteredDesigns.isEmpty {
                    emptyGalleryView
                } else {
                    galleryContent
                }
            }
            .navigationTitle("My Designs")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.toggleViewMode()
                    }) {
                        Image(systemName: viewModel.viewMode == .grid ? "list.bullet" : "square.grid.2x2")
                    }
                }
            }
            .sheet(isPresented: $showingFilterOptions) {
                filterOptionsSheet
            }
        }
    }
    
    private var searchAndFilterBar: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color("LightText"))
                
                TextField("Search designs", text: $searchText)
                    .foregroundColor(Color("DarkText"))
                    .onChange(of: searchText) { newValue in
                        viewModel.filterDesigns(searchText: newValue)
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        viewModel.filterDesigns(searchText: "")
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color("LightText"))
                    }
                }
            }
            .padding()
            .background(Color("LightBackground"))
            
            // Filter bar
            HStack {
                Button(action: {
                    showingFilterOptions = true
                }) {
                    HStack {
                        Image(systemName: "slider.horizontal.3")
                        Text("Filter")
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .stroke(Color("BorderColor"), lineWidth: 1)
                    )
                    .foregroundColor(Color("DarkText"))
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.filterOptions, id: \.self) { option in
                            Button(action: {
                                viewModel.setFilter(option)
                            }) {
                                Text(option)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule()
                                            .fill(viewModel.currentFilter == option ? Color("PrimaryBlue") : Color("LightBackground"))
                                    )
                                    .foregroundColor(viewModel.currentFilter == option ? .white : Color("DarkText"))
                            }
                        }
                    }
                }
                
                Spacer()
                
                Menu {
                    Button("Newest First") {
                        viewModel.setSortOption(.newest)
                    }
                    
                    Button("Oldest First") {
                        viewModel.setSortOption(.oldest)
                    }
                    
                    Button("A-Z") {
                        viewModel.setSortOption(.nameAscending)
                    }
                    
                    Button("Z-A") {
                        viewModel.setSortOption(.nameDescending)
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .foregroundColor(Color("DarkText"))
                }
            }
            .padding()
            .background(Color("Background"))
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
    
    private var galleryContent: some View {
        ScrollView {
            if viewModel.viewMode == .grid {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
                    ForEach(viewModel.filteredDesigns) { design in
                        NavigationLink(destination: DesignDetailView(design: design)) {
                            DesignCard(design: design)
                                .frame(height: 220)
                        }
                    }
                    
                    NavigationLink(destination: DesignerView()) {
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color("LightBackground"))
                                    .frame(height: 160)
                                
                                Image(systemName: "plus")
                                    .font(.system(size: 32))
                                    .foregroundColor(Color("PrimaryBlue"))
                            }
                            
                            Text("Create New")
                                .font(.headline)
                                .foregroundColor(Color("DarkText"))
                                .padding(.top, 8)
                            
                            Spacer()
                        }
                        .frame(height: 220)
                    }
                }
                .padding()
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.filteredDesigns) { design in
                        NavigationLink(destination: DesignDetailView(design: design)) {
                            HStack(spacing: 16) {
                                // Design thumbnail
                                Image(design.thumbnail)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(8)
                                
                                // Design info
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(design.name)
                                        .font(.headline)
                                        .foregroundColor(Color("DarkText"))
                                    
                                    Text(design.createdAt)
                                        .font(.caption)
                                        .foregroundColor(Color("LightText"))
                                    
                                    // Tags would go here in a real implementation
                                }
                                
                                Spacer()
                                
                                // Favorite button
                                Button(action: {
                                    viewModel.toggleFavorite(design)
                                }) {
                                    Image(systemName: design.isFavorite ? "heart.fill" : "heart")
                                        .foregroundColor(design.isFavorite ? .red : Color("LightText"))
                                }
                            }
                            .padding()
                            .background(Color("Background"))
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                    }
                    
                    NavigationLink(destination: DesignerView()) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(Color("PrimaryBlue"))
                            
                            Text("Create New Design")
                                .font(.headline)
                                .foregroundColor(Color("PrimaryBlue"))
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color("Background"))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                }
                .padding()
            }
        }
    }
    
    private var emptyGalleryView: some View {
        VStack(spacing: 24) {
            Image(systemName: "tshirt")
                .font(.system(size: 64))
                .foregroundColor(Color("LightText"))
            
            Text("No designs yet")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color("DarkText"))
            
            Text("Create your first design to get started")
                .font(.body)
                .foregroundColor(Color("LightText"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            NavigationLink(destination: DesignerView()) {
                Text("Create Design")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color("PrimaryBlue"))
                    .cornerRadius(8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Background"))
    }
    
    private var filterOptionsSheet: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {
                // Date filters
                VStack(alignment: .leading, spacing: 16) {
                    Text("Date")
                        .font(.headline)
                        .foregroundColor(Color("DarkText"))
                    
                    VStack(spacing: 12) {
                        filterOptionButton("Last 7 days", isSelected: viewModel.dateFilter == .lastWeek)
                        filterOptionButton("Last 30 days", isSelected: viewModel.dateFilter == .lastMonth)
                        filterOptionButton("Last 90 days", isSelected: viewModel.dateFilter == .last3Months)
                        filterOptionButton("All time", isSelected: viewModel.dateFilter == .allTime)
                    }
                }
                
                // Favorites filter
                VStack(alignment: .leading, spacing: 16) {
                    Text("Favorites")
                        .font(.headline)
                        .foregroundColor(Color("DarkText"))
                    
                    Toggle("Show favorites only", isOn: $viewModel.showFavoritesOnly)
                        .foregroundColor(Color("DarkText"))
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Filter Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        viewModel.resetFilters()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        viewModel.applyFilters()
                        showingFilterOptions = false
                    }
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryBlue"))
                }
            }
        }
    }
    
    private func filterOptionButton(_ title: String, isSelected: Bool) -> some View {
        Button(action: {
            viewModel.setDateFilter(title)
        }) {
            HStack {
                Text(title)
                    .foregroundColor(Color("DarkText"))
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color("PrimaryBlue"))
                }
            }
            .padding()
            .background(Color("LightBackground"))
            .cornerRadius(8)
        }
    }
}

struct DesignDetailView: View {
    let design: Design
    @State private var showingActionSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Design image
                Image(design.thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(12)
                
                // Design info
                VStack(alignment: .leading, spacing: 8) {
                    Text(design.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color("DarkText"))
                    
                    Text("Created on \(design.createdAt)")
                        .font(.subheadline)
                        .foregroundColor(Color("LightText"))
                }
                
                // Action buttons
                HStack(spacing: 16) {
                    actionButton("Edit", systemImage: "pencil") {
                        // Navigate to designer view with this design
                    }
                    
                    actionButton("Search", systemImage: "magnifyingglass") {
                        // Navigate to search with this design
                    }
                    
                    actionButton("Alert", systemImage: "bell") {
                        // Navigate to alert creation
                    }
                    
                    actionButton("Share", systemImage: "square.and.arrow.up") {
                        showingActionSheet = true
                    }
                }
                
                // Design details would go here in a real implementation
                // For example, fabric information, color palette, etc.
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Design Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        // Edit design
                    }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(action: {
                        // Duplicate design
                    }) {
                        Label("Duplicate", systemImage: "plus.square.on.square")
                    }
                    
                    Button(role: .destructive, action: {
                        // Delete design
                    }) {
        
(Content truncated due to size limit. Use line ranges to read in chunks)