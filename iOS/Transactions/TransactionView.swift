//
//  TransactionView.swift
//  HouseholdBills
//
//  Created by Pablo Albella on 8/15/21.
//

import SwiftUI


struct TransactionView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var offset: CGFloat = 0
    
    @State var loading = false
       @State private var alternate: Bool = true
    @State var commandLeftTrigger: Bool = false
    @State var commandRightTrigger: Bool = false
    
    @State var filters: TransactionFiltersModel = TransactionFiltersModel()
    
    @Binding var showSubscribe: Bool
    
    var body: some View {
          
                            
                            VStack {
                            
                            GeometryReader { proxy in
                                
                                HeaderView(title: "Transactions", commandLeft: "", commandRight: "slider.horizontal.3", commandLeftTrigger: $commandLeftTrigger, commandRightTrigger: $commandRightTrigger)

                            }
                            .frame(height: ui.headerHeight - 10)
                            .offset(y: 0)
                            .zIndex(1)
                            
                                RefreshableScrollView(height: 70, refreshing: self.$loading) {
                                
                                  
                                    TransactionsBodyView(filters: $filters, loading: $loading)
                                        .padding(.top, 30)
                                    
                                
                            }
                                
                                Divider()
                            }
                            .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
                            .sheet(isPresented: self.$commandRightTrigger, onDismiss: {
                                
                                self.loading = true
                                
                     

                            }) { TransactionFilterView(filters: $filters, modal: $commandRightTrigger)}
                            .modifier(OffsetModifier(offset: $offset))
                            .ignoresSafeArea()
                            .edgesIgnoringSafeArea([.top, .bottom])

        
    }
}
    





//#if DEBUG
//struct TransactionView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        TransactionView().environmentObject(UserSettings())
//            .environmentObject(AppUI())
//    }
//}
//#endif


