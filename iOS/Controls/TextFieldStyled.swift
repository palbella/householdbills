//
//  TextFieldStyled.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 11/1/21.
//

import Foundation
import SwiftUI

struct AppTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(20)
                .shadow(color: .gray, radius: 10)
        }
}

struct AppButtonStyle: ButtonStyle {
 
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .padding(.bottom, 5)
            .padding(.top, 5)
            .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
            .background(LinearGradient(gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
            .padding(.horizontal, 20)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
