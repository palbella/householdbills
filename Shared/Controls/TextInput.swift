//
//  SwipeItem.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI


struct TextInput: View {
   
    var labelColor: Color
    var fontColor: Color
    var iconContent: String
    var iconColor: Color
    var maxLength: Int? = 16
  
    var label: String
    @Binding var value: String
    
  
    var body: some View {
       
            HStack (spacing: 0) {
                if(iconContent != "") {
                    Icon(content: iconContent, color: iconColor).padding(5).padding(.leading, 5).padding(.trailing, 5)
                } else {
                    Text("   ")
                }
                
 
                Text(LocalizedStringKey(label))
                .foregroundColor(labelColor)

                    
            Spacer()
                CustomTextfield(label: label, text: $value, keyType: UIKeyboardType.alphabet, textAlignment: .right,
                                maxLength: maxLength).padding(5).padding(.leading, 5).padding(.trailing, 5)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(fontColor)

        
                
        }
//        .frame(width: .infinity)
            .padding(.top, 10)
            .padding(.bottom, 10)
       
            
          
        
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
