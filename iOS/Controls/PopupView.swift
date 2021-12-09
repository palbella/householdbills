//
//  PopupView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 12/5/21.
//

import Foundation
import SwiftUI

struct PopUpWindow: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    
    @Binding var isShowingPopup: Bool
    @Binding var popupTitle: String
    @Binding var popupMessasge: String
    @Binding var popupImage: String

    var body: some View {
        ZStack {
            if isShowingPopup {
                // PopUp background color
                Color.black.opacity(isShowingPopup ? 0.3 : 0).edgesIgnoringSafeArea(.all)

                // PopUp Window
                VStack(alignment: .center, spacing: 0) {
                    Text(popupTitle)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45, alignment: .center)
                        .font(Font.system(size: 23, weight: .semibold))
                        .foregroundColor(Color.white)
                        .background(ui.lightPrimaryColor)

                    Text(popupMessasge)
                        .multilineTextAlignment(.center)
                        .font(Font.system(size: 16, weight: .semibold))
                        .padding(EdgeInsets(top: 20, leading: 25, bottom: 20, trailing: 25))
                        .foregroundColor(Color.black)
                    
                    if(popupImage != "") {
                        Image(popupImage)
                            .resizable()
                                .scaledToFit()
                                .frame(width: 250.0, height: 250.0)
                    }

                    Button(action: {
                        // Dismiss the PopUp
                        withAnimation(.linear(duration: 0.3)) {
                            isShowingPopup = false
                        }
                    }, label: {
                        Text("OK")
                            .frame(maxWidth: .infinity)
                            .frame(height: 54, alignment: .center)
                            .foregroundColor(Color.white)
                            .background(ui.lightPrimaryColor)
                            .font(Font.system(size: 23, weight: .semibold))
                    }).buttonStyle(PlainButtonStyle())
                }
                .frame(maxWidth: 300)
                .border(Color.white, width: 2)
                .background(Color.white)
            }
        }
    }
}
