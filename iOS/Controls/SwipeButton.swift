//
//  SwipeItem.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI


struct SwipeButton: View {
    var content: String
    var color: Color
    var colorIcon: Color = .white
    
  
    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
            
            Image(systemName: content)
                .foregroundColor(colorIcon)
                .font(.largeTitle)
        }
    }
}
