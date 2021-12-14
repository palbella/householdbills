//
//  SwipeItem.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI


struct PinInput: View {
  
    var label: String
    @Binding var value: String
    
  
    var body: some View {
       
            HStack (spacing: 0) {
                PasscodeField(label: label, handler:{ pin, result in
                   
                    if(pin == "000000") {
                        self.value = ""
                        return false
                    }
                    self.value = pin
                    return true
                })
        
                
        }
//        .frame(width: .infinity)
            .padding(.top, 10)
            .padding(.bottom, 10)
       
            
          
        
    }
}
