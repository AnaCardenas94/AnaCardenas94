//
//  ContentView.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 05/11/25.
//
import SwiftUI
internal import Combine
import Foundation
import SwiftUI

struct WalkthroughView: View {

    var body: some View {
        NavigationStack {
            VStack(spacing: 50) {
                SliderView()
                    .frame(height: 500)
                    .padding(.top, 70)
                    .padding(.horizontal, 20)
                
                NavigationLink(destination: LoginView()) {
                    Text("Let's Get Started")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .background(Color(red: 0.06, green: 0.27, blue: 0.39))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct SliderView: View {

    
    @State private var selection = 0

    let images = ["SlideOne","SlideSecond","SlideForth"]
    public let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.white
            
            TabView(selection: $selection) {
                ForEach(0..<images.count, id: \.self) { i in
                    Image(images[i])
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                        .tag(i)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .onReceive(timer) { _ in
                withAnimation {
                    selection = (selection + 1) % images.count
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct ExploreNews_Previews: PreviewProvider {
    static var previews: some View {
        WalkthroughView()
    }
}

#Preview {
    WalkthroughView()
}
