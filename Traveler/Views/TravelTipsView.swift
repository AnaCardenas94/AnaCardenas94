//
//  Tips.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 10/11/25.
//

import SwiftUI

struct TravelTipsView: View {

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("✈️ Tips para Viajar")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 10)
                
                TipCard(
                    icon: "suitcase.fill",
                    title: "Empaca ligero",
                    subtitle: "Lleva solo lo necesario para evitar peso extra y moverte con facilidad."
                )
                
                TipCard(
                    icon: "icloud.and.arrow.down.fill",
                    title: "Guarda documentos en la nube",
                    subtitle: "Ten copias digitales de tu pasaporte, tickets y reservas."
                )
                
                TipCard(
                    icon: "figure.walk.circle.fill",
                    title: "Explora caminando",
                    subtitle: "Es la mejor manera de descubrir lugares ocultos y ahorrar dinero."
                )
                
                TipCard(
                    icon: "wifi",
                    title: "Descarga mapas offline",
                    subtitle: "Útil si no tienes conexión estable en tu destino."
                )
                
                TipCard(
                    icon: "heart.text.square.fill",
                    title: "Aprende frases básicas",
                    subtitle: "Un par de palabras en el idioma local ayuda muchísimo."
                )
            }
            .padding()
        }
        .background(Color(UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)))
    }
}

struct TipCard: View {
    var icon: String
    var title: String
    var subtitle: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(Color(UIColor(red: 0.06, green: 0.27, blue: 0.39, alpha: 1.0)))
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
    }
}

struct TravelTipsView_Previews: PreviewProvider {
    static var previews: some View {
        TravelTipsView()
    }
}

#Preview {
    TravelTipsView()
}
