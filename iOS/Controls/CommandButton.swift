//
//  SwipeItem.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI


struct CommandButton: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    
    var content: String
  
    var body: some View {
        VStack (spacing: 0) {
            HStack (spacing: 0) {
          
            
                VStack (spacing: 0) {
                    Spacer()
                HStack (spacing: 0) {
 
                    
            Spacer()
             

                        Image(systemName: content)
                            .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                            
                    
                }
                }
        }
        .frame(maxWidth: .infinity)
       
            
          
        }
    }
}



#if DEBUG
struct commandView_Previews: PreviewProvider {
    
    static var previews: some View {
        CommandButton(content: "plus").environmentObject(UserSettings())
            .environmentObject(AppUI())
    }
}
#endif
