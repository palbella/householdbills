//
//  TransactionView.swift
//  HouseholdBills
//
//  Created by Pablo Albella on 8/15/21.
//

import SwiftUI


struct PlanningView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.colorScheme) var colorScheme
    
    @State var offset: CGFloat = 0
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    @State var commandLeftTrigger: Bool = false
    @State var commandRightTrigger: Bool = false
    
    @Binding var showSubscribe: Bool
    
    @Binding var isShowingPopup: Bool
    @Binding var popupMessasge: String
    @Binding var popupTitle: String
    @Binding var popupImage: String
    
    var body: some View {
          
                            
                            VStack {
                            
                            GeometryReader { proxy in
                                
                                HeaderView(title: "Monthly Planning", commandLeft: "", commandRight: "", commandLeftTrigger: $commandLeftTrigger, commandRightTrigger: $commandRightTrigger)
                 
                                
                            }
                            .frame(height: 40)
                            .offset(y: 0)
                            .zIndex(1)
                            
                                ScrollView(.vertical, showsIndicators: false) {
                                
                                    PlanningBodyView(isShowingToast: $isShowingToast, toastMessasge: $toastMessasge, toastError: $toastError, isShowingPopup: $isShowingPopup, popupMessasge: $popupMessasge, popupTitle: self.$popupTitle, popupImage: self.$popupImage, showSubscribe: self.$showSubscribe)
                                    .padding(.top, 80)
                                
                            }
                                Divider()
                                
                            }
                            .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
                            .modifier(OffsetModifier(offset: $offset))
                            .ignoresSafeArea()
                            .edgesIgnoringSafeArea([.top, .bottom])
                            
               
  
     
        
    }
}
    


//#if DEBUG
//struct PlanningView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        PlanningView().environmentObject(UserSettings())
//            .environmentObject(AppUI())
//    }
//}
//#endif

