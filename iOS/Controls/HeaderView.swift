//
//  HeaderView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/26/21.
//

import SwiftUI


struct HeaderView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    
    var title: String
    var commandLeft: String
    var commandRight: String
    @Binding var commandLeftTrigger: Bool
    @Binding var commandRightTrigger: Bool
  
    var body: some View {
       
            VStack() {
                Spacer()
                HStack {
                    Button(action: {
                        self.commandLeftTrigger = true
                    }) {
                        Image(systemName: commandLeft)
                            .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                        .frame(width: 20)
                        .padding(.leading, 20)
                       .padding(.top, 8)
                            .padding(.bottom, 4)
                    }
                   
                    Spacer()
                    Text(LocalizedStringKey(title))
                        .font(ui.title)
                        .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                    Spacer()
                    Button(action: {
                        self.commandRightTrigger = true
                    }) {
                        Image(systemName: commandRight)
                            .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                            .frame(width: 20)
                            .padding(.top, 8)
                            .padding(.bottom, 4)
                            .padding(.trailing, 20)
                    }
                    
                }
                
                Divider()
            }
            .frame(maxWidth: .infinity)
            .frame(height: ui.headerHeight, alignment: .bottom)
            .background(colorScheme != .dark ? ui.lightMainBackgroundColor: ui.darkMainBackgroundColor)
            
        

    }
}




//#if DEBUG
//struct headerView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        HeaderView(title: "Title", commandLeft: "", commandRight: "pencil").environmentObject(UserSettings())
//            .environmentObject(AppUI())
//    }
//}
//#endif

