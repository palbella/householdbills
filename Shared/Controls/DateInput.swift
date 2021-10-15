//
//  SwipeItem.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI


struct DateInput: View {
   
    var labelColor: Color
    var fontColor: Color
    var iconContent: String
    var iconColor: Color
  
    var label: String
    @Binding var value: Date
    
  
    var body: some View {
       
        DatePicker(
            LocalizedStringKey(label),
                selection: $value,
                displayedComponents: [.date]
        ).padding(.leading, 15)
       
            
          
        
    }
}


//#if DEBUG
//struct textInputView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        TextInput(iconContent: "pencil", iconColor: Color.blue, label: "AA", value: .constant("CC")).environmentObject(UserSettings())
//            .environmentObject(AppUI())
//    }
//}
//#endif
