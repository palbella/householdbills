//
//  SwipeItem.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI


struct ItemSpace: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
  
    var body: some View {
        VStack (spacing: 0) {
            HStack (spacing: 0) {
//
//                VStack (spacing: 0) {
//                    Spacer()
//                HStack (spacing: 0) {
//
//          Spacer()
//
//                }
//                    Spacer()
//
//                }
        }
        .frame(maxWidth: .infinity)
            .padding(3)
        }
        .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
       
        
    }
}
