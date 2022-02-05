//
//  SwipeItem.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI


struct DoubleInput: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    
    var labelColor: Color
    var fontColor: Color
    var iconContent: String
    var iconColor: Color
  
    var label: String
    @Binding var value: Double
    
  
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
                CurrencyField(
                            "Amount", symbol: "",
                            value: Binding(get: {
                                return Decimal(value) as NSDecimalNumber
                            }, set: { number in
                                var result: Double = 0
                                if(number != nil) {
                                    result = Double(truncating: number!.decimalValue as NSNumber).truncate(places: 2)
                                }
                                
                                value = result
                            }
                            ),
                        foregroundColor: UIColor(fontColor),
                            maxLength: 10
                        ).padding(5).padding(.leading, 5).padding(.trailing, 5)
                
        }
            .padding(.top, 10)
            .padding(.bottom, 10)
            
          
        
    }
}


//#if DEBUG
//struct doubleInputView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        DoubleInput(iconContent: "pencil", iconColor: Color.blue, label: "AA", value: .constant(0)).environmentObject(UserSettings())
//            .environmentObject(AppUI())
//    }
//}
//#endif
