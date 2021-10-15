//
//  SwipeItem.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI


struct Icon: View {
    var content: String
    var color: Color
    
  
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(color)
                .frame(width: 26, height: 26)
            
            if((UIImage(named:content)) != nil) {
                
                Image(uiImage: UIImage(named:content) ?? UIImage())
                    .resizable()
                            .frame(width: 20, height: 20)
//                !.addImagePadding(x: 10, y: 10)
            } else {
                Image(systemName: content)
                                .foregroundColor(.white)
                    .font(.system(size: 15, weight: .heavy)) //, weight: .heavy
            }
                
        }
    }
    
  
}
