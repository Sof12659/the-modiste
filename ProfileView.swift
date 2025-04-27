import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingLogoutConfirmation = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile header
                    profileHeader
                    
                    // Stats summary
                    statsSummary
                    
                    // Settings sections
                    settingsSections
                }
                .padding()
            }
            .navigationTitle("Profile")
            .actionSheet(isPresented: $showingLogoutConfirmation) {
                ActionSheet(
                    title: Text("Logout"),
                    message: Text("Are you sure you want to logout?"),
                    buttons: [
                        .destructive(Text("Logout")) {
                            viewModel.logout()
                        },
                        .cancel()
                    ]
                )
            }
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            // Profile image
            Image(viewModel.profileImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color("PrimaryBlue"), lineWidth: 3)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            // User name
            Text(viewModel.userName)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("DarkText"))
            
            // User email
            Text(viewModel.userEmail)
                .font(.subheadline)
                .foregroundColor(Color("LightText"))
            
            // Edit profile button
            Button(action: {
                // Navigate to edit profile
            }) {
                Text("Edit Profile")
                    .font(.headline)
                    .foregroundColor(Color("PrimaryBlue"))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("PrimaryBlue"), lineWidth: 1)
                    )
            }
        }
        .padding()
        .background(Color("Background"))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var statsSummary: some View {
        HStack(spacing: 0) {
            statItem(count: viewModel.designsCount, label: "Designs")
            
            Divider()
                .frame(height: 40)
            
            statItem(count: viewModel.alertsCount, label: "Alerts")
            
            Divider()
                .frame(height: 40)
            
            statItem(count: viewModel.favoritesCount, label: "Favorites")
        }
        .padding()
        .background(Color("Background"))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private func statItem(count: Int, label: String) -> some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color("DarkText"))
            
            Text(label)
                .font(.caption)
                .foregroundColor(Color("LightText"))
        }
        .frame(maxWidth: .infinity)
    }
    
    private var settingsSections: some View {
        VStack(spacing: 24) {
            // Account settings
            settingsSection(
                title: "Account Settings",
                items: [
                    SettingsItem(icon: "person", title: "Personal Information", destination: AnyView(Text("Personal Information"))),
                    SettingsItem(icon: "lock", title: "Security", destination: AnyView(Text("Security"))),
                    SettingsItem(icon: "creditcard", title: "Payment Methods", destination: AnyView(Text("Payment Methods")))
                ]
            )
            
            // Measurements
            settingsSection(
                title: "Measurements",
                items: [
                    SettingsItem(icon: "ruler", title: "Body Measurements", destination: AnyView(MeasurementsView()))
                ]
            )
            
            // Style preferences
            settingsSection(
                title: "Style Preferences",
                items: [
                    SettingsItem(icon: "heart", title: "Favorite Styles", destination: AnyView(StylePreferencesView())),
                    SettingsItem(icon: "tag", title: "Favorite Retailers", destination: AnyView(Text("Favorite Retailers")))
                ]
            )
            
            // Notification settings
            settingsSection(
                title: "Notification Settings",
                items: [
                    SettingsItem(icon: "bell", title: "Push Notifications", destination: AnyView(Text("Push Notifications"))),
                    SettingsItem(icon: "envelope", title: "Email Notifications", destination: AnyView(Text("Email Notifications")))
                ]
            )
            
            // Help & support
            settingsSection(
                title: "Help & Support",
                items: [
                    SettingsItem(icon: "questionmark.circle", title: "FAQ", destination: AnyView(Text("FAQ"))),
                    SettingsItem(icon: "envelope", title: "Contact Us", destination: AnyView(Text("Contact Us"))),
                    SettingsItem(icon: "doc.text", title: "Terms of Service", destination: AnyView(Text("Terms of Service"))),
                    SettingsItem(icon: "hand.raised", title: "Privacy Policy", destination: AnyView(Text("Privacy Policy")))
                ]
            )
            
            // About
            settingsSection(
                title: "About",
                items: [
                    SettingsItem(icon: "info.circle", title: "App Version", destination: AnyView(Text("App Version")), showArrow: false, detail: "1.0.0"),
                    SettingsItem(icon: "star", title: "Rate the App", destination: AnyView(Text("Rate the App")))
                ]
            )
            
            // Logout button
            Button(action: {
                showingLogoutConfirmation = true
            }) {
                HStack {
                    Image(systemName: "arrow.right.square")
                        .foregroundColor(.red)
                    
                    Text("Logout")
                        .foregroundColor(.red)
                    
                    Spacer()
                }
                .padding()
                .background(Color("Background"))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            }
        }
    }
    
    private func settingsSection(title: String, items: [SettingsItem]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color("DarkText"))
            
            VStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { index in
                    NavigationLink(destination: items[index].destination) {
                        HStack {
                            Image(systemName: items[index].icon)
                                .frame(width: 24)
                                .foregroundColor(Color("PrimaryBlue"))
                            
                            Text(items[index].title)
                                .foregroundColor(Color("DarkText"))
                            
                            Spacer()
                            
                            if let detail = items[index].detail {
                                Text(detail)
                                    .font(.subheadline)
                                    .foregroundColor(Color("LightText"))
                            }
                            
                            if items[index].showArrow {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("LightText"))
                            }
                        }
                        .padding()
                        .background(Color("Background"))
                    }
                    
                    if index < items.count - 1 {
                        Divider()
                            .padding(.leading, 48)
                    }
                }
            }
            .background(Color("Background"))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}

struct MeasurementsView: View {
    @State private var bust: String = "36"
    @State private var waist: String = "28"
    @State private var hips: String = "38"
    @State private var height: String = "5'6\""
    @State private var weight: String = "130"
    @State private var selectedSize: String = "Medium"
    
    let sizeOptions = ["X-Small", "Small", "Medium", "Large", "X-Large"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Your body measurements help us find the perfect fit for you.")
                    .font(.subheadline)
                    .foregroundColor(Color("LightText"))
                
                // Measurements form
                VStack(spacing: 16) {
                    measurementField(title: "Bust", value: $bust, unit: "inches")
                    measurementField(title: "Waist", value: $waist, unit: "inches")
                    measurementField(title: "Hips", value: $hips, unit: "inches")
                    measurementField(title: "Height", value: $height, unit: "")
                    measurementField(title: "Weight", value: $weight, unit: "lbs")
                    
                    // Standard size
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Standard Size")
                            .font(.headline)
                            .foregroundColor(Color("DarkText"))
                        
                        Picker("Standard Size", selection: $selectedSize) {
                            ForEach(sizeOptions, id: \.self) { size in
                                Text(size).tag(size)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                // Save button
                Button(action: {
                    // Save measurements
                }) {
                    Text("Save Measurements")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("PrimaryBlue"))
                        .cornerRadius(8)
                }
                .padding(.top, 16)
            }
            .padding()
        }
        .navigationTitle("Measurements")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func measurementField(title: String, value: Binding<String>, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color("DarkText"))
            
            HStack {
                TextField("", text: value)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color("LightBackground"))
                    .cornerRadius(8)
                
                if !unit.isEmpty {
                    Text(unit)
                        .foregroundColor(Color("LightText"))
                }
            }
        }
    }
}

struct StylePreferencesView: View {
    @State private var selectedStyles: Set<String> = ["Casual", "Minimalist"]
    @State private var selectedColors: Set<String> = ["Blue", "Black", "White"]
    
    let styleOptions = ["Casual", "Formal", "Athletic", "Bohemian", "Vintage", "Minimalist", "Streetwear", "Preppy"]
    let colorOptions = ["Black", "White", "Gray", "Blue", "Red", "Green", "Yellow", "Purple", "Pink", "Brown", "Orange", "Teal"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Your style preferences help us recommend designs and products that match your taste.")
                    .font(.subheadline)
                    .foregroundColor(Color("LightText"))
                
                // Favorite styles
                VStack(alignment: .leading, spacing: 16) {
                    Text("Favorite Styles")
                        .font(.headline)
                        .foregroundColor(Color("DarkText"))
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                        ForEach(styleOptions, id: \.self) { style in
                            styleButton(style, isSelected: selectedStyles.contains(style))
                        }
                    }
                }
                
                // Favorite colors
                VStack(alignment: .leading, spacing: 16) {
                    Text("Favorite Colors")
                        .font(.headline)
                        .foregroundColor(Color("DarkText"))
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 12) {
                        ForEach(colorOptions, id: \.self) { color in
                            colorButton(color, isSelected: selectedColors.contains(color))
                        }
                    }
                }
                
                // Save button
                Button(action: {
                    // Save preferences
                }) {
                    Text("Save Preferences")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("PrimaryBlue"))
                        .cornerRadius(8)
                }
                .padding(.top, 16)
            }
            .padding()
        }
        .navigationTitle("Style Preferences")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func styleButton(_ style: String, isSelected: Bool) -> some View {
        Button(action: {
            if isSelected {
                selectedStyles.remove(style)
            } else {
                selectedStyles.insert(style)
            }
        }) {
            Text(style)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(minWidth: 100)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color("PrimaryBlue") : Color("LightBackground"))
                )
                .foregroundColor(isSelected ? .white : Color("DarkText"))
        }
    }
    
    private func colorButton(_ colorName: String, isSelected: Bool) -> some View {
        Button(action: {
            if isSelected {
                selectedColors.remove(colorName)
            } else {
         
(Content truncated due to size limit. Use line ranges to read in chunks)