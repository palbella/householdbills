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
                        .foregroundColor(ui.lightCommandFontColor)
       
                    
                }
                }
        }
        .frame(maxWidth: .infinity)
       
            
          
        }
    }
}

struct CommandAnimationButton: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    
    var content: String
    
    @State var animationStatus = false
    @Binding var animation: Bool
    
    init(content: String, animation: Binding<Bool>) {
        self.content = content
        self._animation = animation
    }
  
    var body: some View {
        VStack (spacing: 0) {
            HStack (spacing: 0) {
          
            
                VStack (spacing: 0) {
                    Spacer()
                HStack (spacing: 0) {
 
                    
            Spacer()
             
                    if(self.animation == true) {
                        Image(systemName: content)
                        .foregroundColor(animationStatus ? ui.darkPrimaryColor: ui.lightCommandFontColor)
                        .font(.system(size: 18, weight: .bold, design: .default))
                            .onAppear(perform: {
                            
                                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)){
                                    
                                        animationStatus.toggle()
                                   
                                }
                            })
                    } else {
                        Image(systemName: content)
                        .foregroundColor(ui.lightCommandFontColor)
                    }
                      
                    
                }
                }
        }
        .frame(maxWidth: .infinity)
       
            
          
        }
    }
}


struct CommandAnimationBorder: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    
    
    @State var animationStatus = false
    @Binding var animation: Bool
    
    init(animation: Binding<Bool>) {
        self._animation = animation
    }
  
    var body: some View {

                    if(self.animation == true) {
                        Divider().frame(height: 1).background(animationStatus ? ui.darkPrimaryColor : Color.white)
                            .onAppear(perform: {
                            
                                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)){
                                    
                                        animationStatus.toggle()
                                   
                                }
                            })
                    } else {
                        
                    }
 
    }
}


//#if DEBUG
//struct commandView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        CommandButton(content: "plus").environmentObject(UserSettings())
//            .environmentObject(AppUI())
//    }
//}
//#endif
