//
//  DashboardView.swift
//  HouseholdBills
//
//  Created by Pablo Albella on 8/15/21.
//

import SwiftUI
import Combine
import CoreData



struct DashboardView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext


    @State var offset: CGFloat = 0
   
    @State var totalAccounts: Double = 0
    @State var totalGoalAccounts: Double = 0
    @State var totalGoals: Double = 0
    @State var totalPayments: Double = 0
    @State var totalBudgets: Double = 0
    @State var incomes: Double = 0
    @State var expenses: Double = 0
    
    @State var hideData: Bool = false
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    @Binding var showUser: Bool
    @Binding var showSubscribe: Bool
  
    
    @State var currentMonthName: String = ""
    @ObservedObject var fetchTransactions = FetchTransactions()
    
  
    
    func onAppear() {
        
        self.expenses = abs(fetchTransactions.fetchExpenses(viewContext: viewContext))
        self.incomes = fetchTransactions.fetchIncomes(viewContext: viewContext)
       
    }

    var body: some View {


            VStack(spacing: 0) {
            
            GeometryReader { proxy in
                
             

            }
            .frame(height: ui.headerHeight)
            .zIndex(1)

        ScrollView(.vertical, showsIndicators: false) {

           
        }
      
                
            }
            .ignoresSafeArea()
            .edgesIgnoringSafeArea([.top, .bottom])
            .onAppear() {
                self.onAppear()
            }


    }
    
    

}





//#if DEBUG
//struct DashboardView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        GeometryReader { proxy in
//    //let topEdge = proxy.safeAreaInsets.top
//            DashboardView().environmentObject(UserSettings())
//                .environmentObject(AppUI())
//        }
//    }
//}
//#endif
