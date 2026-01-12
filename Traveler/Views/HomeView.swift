//
//  Home.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 12/11/25.
//
import SwiftUI
import SwiftData
internal import _LocationEssentials

private let mainColor = Color(red: 0.06, green: 0.27, blue: 0.39) // Azul Oscuro Base
private let mainColorWithOpacity = Color(red: 0.06, green: 0.27, blue: 0.39,opacity: 0.8)
private let cardBackgroundColor = Color(red: 0.93, green: 0.93, blue: 0.93)
private let skyBlue = Color(red: 1.0/255.0, green: 180.0/255.0, blue: 234.0/255.0)

struct HomeView: View {

    @Query var users: [User]
    
    var userEmail: String
    var currentUser: User? {
        users.first(where: { $0.email.lowercased() == userEmail.lowercased() })
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .center, spacing: 16) {
                    if let data = currentUser?.foto,
                       let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .foregroundColor(mainColor)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Welcome")
                            .font(.title)
                            .bold()
                        Text(currentUser?.nombreCompleto ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                WeatherCardView()
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                
                VStack(spacing: 20){
                    
                    HStack {
                        Spacer()
                        NavigationLink(destination: TravelTipsView()) {
                            CardView(title: "Tips", systemImage: "lightbulb.fill", color: .secondary, backgroundColor: cardBackgroundColor)
                        }
                        Spacer()
                        NavigationLink(destination: ExchangeCalculatorView()) {
                            CardView(title: "Exchange\nMoney", systemImage: "dollarsign.circle.fill", color: .secondary, backgroundColor: cardBackgroundColor)
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        NavigationLink(destination:
                            TripPlannerView()) {
                            CardView(title: "Trip\nPlanner", systemImage: "calendar", color: .secondary, backgroundColor: cardBackgroundColor)
                        }
                        Spacer()
                        NavigationLink(destination:
                            ExpensesListView()) {
                            CardView(title: "Bills", systemImage: "ticket.fill", color: .secondary, backgroundColor: cardBackgroundColor)
                        }
                        Spacer()
                    }
                }
                
                Spacer()
                
                FooterView(userEmail: userEmail)
            }
            .navigationBarHidden(true)
        }
    }
}

struct WeatherCardView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        HStack {
            if let loc = locationManager.location {
                
                VStack(alignment: .leading, spacing: 8) {
                    if locationManager.city != nil {
                        Text("\(locationManager.city ?? ""), \(locationManager.country ?? "")")
                            .font(.headline)
                    } else {
                        Text("\(viewModel.location)")
                    }

                    Text("\(viewModel.temperature ?? 0, specifier: "%.1f")°C | \(viewModel.weatherStatus)")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .onAppear {
                    Task {
                        await viewModel.loadWeather(
                            latitude: loc.coordinate.latitude,
                            longitude: loc.coordinate.longitude
                        )
                    }
                }
                
            } else {
                Text("Getting location...")
                    .foregroundColor(.white)
            }

            Spacer()
            Image(viewModel.weatherIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .clipped()
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.cyan, .blue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
        )
    }
}


struct CardView: View {
    var title: String
    var systemImage: String
    var color: Color
    var backgroundColor: Color

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: systemImage)
                .font(.system(size: 40))
                .foregroundColor(color)

            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .padding(.horizontal, 8)
        }
        .frame(width: 150, height: 180)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor)
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        )
    }
}

struct FooterView: View {
    let userEmail: String

    var body: some View {
        HStack {
            Spacer()
            NavigationLink(destination: HomeView(userEmail: userEmail)) {
                VStack {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            }
            Spacer()
            NavigationLink(destination: ProfileView(userEmail: userEmail)) {
                VStack {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
            }
            Spacer()
            NavigationLink(destination: SettingsView(userEmail: userEmail)) {
                VStack {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
            }
            
            Spacer()
        }
        .padding()
        .background(mainColor)
        .foregroundColor(.white)
    }
}
