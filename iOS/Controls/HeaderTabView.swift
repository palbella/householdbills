//
//  HeaderView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/26/21.
//

import SwiftUI


struct HeaderTabView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    
    var title: String
    
  
    var body: some View {
       
        GeometryReader { proxy in
            
                VStack(spacing: 0) {
                Spacer()
                HStack {
                   
                    Spacer()
                    Text(LocalizedStringKey(title))
                        .font(ui.title)
                        .font(.system(size: 30, weight: .heavy, design: .default))
                        .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                        .padding(.bottom, 13)
                       
                    Spacer()
                   
                }
                
                Divider()
            }
            .frame(height: 55, alignment: .center)
            .background(colorScheme != .dark ? Color.white: ui.darkBackgroundColor)

        }
        .frame(height: 55)
        .offset(y: 0)
        .zIndex(1)

    }
}


struct HeaderTabTitleView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    
    var title: String
    
  
    var body: some View {
       
        if(settings.fastApply != true) {
            Text(title)
                .font(.system(size: 20, weight: .bold, design: .default))
                .accessibilityAddTraits(.isHeader)
                .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
                .padding(.bottom, 20)
                .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
                
        } else {
            Text("")
                .font(.system(size: 20, weight: .bold, design: .default))
                .accessibilityAddTraits(.isHeader)
                .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
                .padding(.bottom, 20)
                .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
        }

    }
}



