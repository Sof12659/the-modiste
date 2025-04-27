import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    welcomeSection
                    
                    recentDesignsSection
                    
                    activeAlertsSection
                    
                    recentMatchesSection
                }
                .padding()
            }
            .navigationTitle("Home")
            .background(Color("LightBackground").ignoresSafeArea())
        }
    }
    
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome back,")
                .font(.title3)
                .foregroundColor(Color("LightText"))
            
            Text(viewModel.userName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color("DarkText"))
        }
    }
    
    private var recentDesignsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Your Recent Designs", actionText: "View All")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.recentDesigns) { design in
                        DesignCard(design: design)
                            .frame(width: 160, height: 220)
                    }
                    
                    createNewDesignCard
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private var activeAlertsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Active Alerts", actionText: "View All")
            
            if viewModel.activeAlerts.isEmpty {
                emptyStateView(
                    icon: "bell.slash",
                    message: "No active alerts",
                    actionText: "Create Alert"
                )
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.activeAlerts) { alert in
                        AlertCard(alert: alert)
                    }
                }
            }
        }
    }
    
    private var recentMatchesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Recent Matches", actionText: "View All")
            
            if viewModel.recentMatches.isEmpty {
                emptyStateView(
                    icon: "tshirt",
                    message: "No matches found yet",
                    actionText: "Search Products"
                )
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.recentMatches) { match in
                            ProductCard(product: match.product, matchScore: match.matchScore)
                                .frame(width: 160, height: 240)
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
        }
    }
    
    private var createNewDesignCard: some View {
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
    
    private func sectionHeader(title: String, actionText: String) -> some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color("DarkText"))
            
            Spacer()
            
            Button(action: {
                // Action for view all
            }) {
                Text(actionText)
                    .font(.subheadline)
                    .foregroundColor(Color("PrimaryBlue"))
            }
        }
    }
    
    private func emptyStateView(icon: String, message: String, actionText: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(Color("LightText"))
            
            Text(message)
                .font(.headline)
                .foregroundColor(Color("LightText"))
            
            Button(action: {
                // Action for empty state
            }) {
                Text(actionText)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color("PrimaryBlue"))
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(Color("Background"))
        .cornerRadius(12)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
