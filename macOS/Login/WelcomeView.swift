//
//  WelcomeView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 10/10/21.
//

import SwiftUI

struct OnboardingModel {
    var id: Int
    var image: String
    var titleText: String
    var descriptionText: String
    var showButton: Bool?
}

struct WelcomeView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.colorScheme) var colorScheme
    
    var onboardingDataArray: [OnboardingModel] = [
        OnboardingModel(id: 1, image: "welcome1", titleText: LocalizedStringKey("WelcomeTitle1").toString(), descriptionText: LocalizedStringKey("WelcomeDescription1").toString()),
        OnboardingModel(id: 2, image: "welcome2", titleText: LocalizedStringKey("WelcomeTitle2").toString(), descriptionText: LocalizedStringKey("WelcomeDescription2").toString()),
        OnboardingModel(id: 3, image: "welcome3", titleText: LocalizedStringKey("WelcomeTitle3").toString(), descriptionText: LocalizedStringKey("WelcomeDescription3").toString()),
        OnboardingModel(id: 4, image: "welcome4", titleText: LocalizedStringKey("WelcomeTitle4").toString(), descriptionText: LocalizedStringKey("WelcomeDescription4").toString()),
        OnboardingModel(id: 5, image: "welcome5", titleText: LocalizedStringKey("WelcomeTitle5").toString(), descriptionText: LocalizedStringKey("WelcomeDescription5").toString(), showButton: true)
    ]
    
    var body: some View {
       Text("Welcome")
}
}
