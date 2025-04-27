import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchText = ""
    @State private var showingFilters = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                searchBar
                
                // Filter bar
                filterBar
                
                // Content
                if searchText.isEmpty && viewModel.searchResults.isEmpty {
                    searchHomeContent
                } else if !viewModel.searchResults.isEmpty {
                    searchResultsContent
                } else {
                    emptyResultsContent
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingFilters) {
                filterSheet
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color("LightText"))
            
            TextField("Search by design or keyword", text: $searchText)
                .foregroundColor(Color("DarkText"))
                .onSubmit {
                    viewModel.search(query: searchText)
                }
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color("LightText"))
                }
            }
        }
        .padding()
        .background(Color("LightBackground"))
    }
    
    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                Button(action: {
                    showingFilters = true
                }) {
                    HStack {
                        Image(systemName: "slider.horizontal.3")
                        Text("Filters")
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .stroke(Color("BorderColor"), lineWidth: 1)
                    )
                    .foregroundColor(Color("DarkText"))
                }
                
                ForEach(viewModel.activeFilters, id: \.self) { filter in
                    HStack {
                        Text(filter)
                        
                        Button(action: {
                            viewModel.removeFilter(filter)
                        }) {
                            Image(systemName: "xmark")
                                .font(.caption)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color("PrimaryBlue").opacity(0.1))
                    )
                    .foregroundColor(Color("PrimaryBlue"))
                }
            }
            .padding()
        }
        .background(Color("Background"))
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var searchHomeContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Search by design section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Search by Design")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("DarkText"))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.recentDesigns) { design in
                                DesignCard(design: design)
                                    .frame(width: 160, height: 220)
                            }
                            
                            NavigationLink(destination: DesignerView()) {
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color("LightBackground"))
                                            .frame(width: 160, height: 160)
                                        
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
                                .frame(width: 160, height: 220)
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
                .padding(.horizontal)
                
                // Popular categories section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Popular Categories")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("DarkText"))
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            Button(action: {
                                viewModel.searchByCategory(category)
                            }) {
                                VStack {
                                    Image(systemName: categoryIcon(for: category))
                                        .font(.system(size: 32))
                                        .foregroundColor(Color("PrimaryBlue"))
                                        .frame(width: 64, height: 64)
                                        .background(Color("PrimaryBlue").opacity(0.1))
                                        .clipShape(Circle())
                                    
                                    Text(category)
                                        .font(.headline)
                                        .foregroundColor(Color("DarkText"))
                                        .padding(.top, 8)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("Background"))
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Recent searches section
                if !viewModel.recentSearches.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Searches")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("DarkText"))
                        
                        VStack(spacing: 12) {
                            ForEach(viewModel.recentSearches, id: \.self) { search in
                                Button(action: {
                                    searchText = search
                                    viewModel.search(query: search)
                                }) {
                                    HStack {
                                        Image(systemName: "clock")
                                            .foregroundColor(Color("LightText"))
                                        
                                        Text(search)
                                            .foregroundColor(Color("DarkText"))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "arrow.up.left")
                                            .foregroundColor(Color("PrimaryBlue"))
                                    }
                                    .padding()
                                    .background(Color("Background"))
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
    
    private var searchResultsContent: some View {
        VStack(spacing: 0) {
            // Results header
            HStack {
                Text("\(viewModel.searchResults.count) results")
                    .font(.subheadline)
                    .foregroundColor(Color("LightText"))
                
                Spacer()
                
                Menu {
                    Button("Price: Low to High") {
                        viewModel.sortResults(by: .priceLowToHigh)
                    }
                    
                    Button("Price: High to Low") {
                        viewModel.sortResults(by: .priceHighToLow)
                    }
                    
                    Button("Match Score") {
                        viewModel.sortResults(by: .matchScore)
                    }
                } label: {
                    HStack {
                        Text("Sort")
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
                
                Button(action: {
                    viewModel.toggleViewMode()
                }) {
                    Image(systemName: viewModel.viewMode == .grid ? "list.bullet" : "square.grid.2x2")
                }
            }
            .padding()
            .background(Color("Background"))
            
            // Results grid/list
            ScrollView {
                if viewModel.viewMode == .grid {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
                        ForEach(viewModel.searchResults) { match in
                            ProductCard(product: match.product, matchScore: match.matchScore)
                                .frame(height: 240)
                        }
                    }
                    .padding()
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.searchResults) { match in
                            HStack(spacing: 16) {
                                // Product image
                                Image(match.product.thumbnail)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(8)
                                
                                // Product info
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(match.product.name)
                                        .font(.headline)
                                        .foregroundColor(Color("DarkText"))
                                    
                                    Text("$\(String(format: "%.2f", match.product.price))")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color("DarkText"))
                                    
                                    Text(match.product.retailer)
                                        .font(.caption)
                                        .foregroundColor(Color("LightText"))
                                }
                                
                                Spacer()
                                
                                // Match score
                                ZStack {
                                    Circle()
                                        .fill(Color("PrimaryBlue"))
                                        .frame(width: 36, height: 36)
                                    
                                    Text("\(match.matchScore)%")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
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
    }
    
    private var emptyResultsContent: some View {
        VStack(spacing: 24) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 64))
                .foregroundColor(Color("LightText"))
            
            Text("No results found")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color("DarkText"))
            
            Text("Try adjusting your search or filters to find what you're looking for.")
                .font(.body)
                .foregroundColor(Color("LightText"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button(action: {
                searchText = ""
                viewModel.clearFilters()
            }) {
                Text("Clear Search")
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
    
    private var filterSheet: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Price range
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Price Range")
                            .font(.headline)
                            .foregroundColor(Color("DarkText"))
                        
                        VStack(spacing: 8) {
                            HStack {
                                Text("$\(Int(viewModel.minPrice))")
                                Spacer()
                                Text("$\(Int(viewModel.maxPrice))")
                            }
                            .foregroundColor(Color("LightText"))
                            
                            Slider(value: $viewModel.minPrice, in: 0...500)
                                .accentColor(
(Content truncated due to size limit. Use line ranges to read in chunks)