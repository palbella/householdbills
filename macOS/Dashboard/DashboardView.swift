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

    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "order", ascending: true)])
    var cardsFetch: FetchedResults<Card>

    @State var offset: CGFloat = 0
   
    @State var totalAccounts: Double = 0
    @State var totalGoalAccounts: Double = 0
    @State var totalGoals: Double = 0
    @State var totalPayments: Double = 0
    @State var totalBudgets: Double = 0
    @State var incomes: Double = 0
    @State var expenses: Double = 0
    
    @State var hideData: Bool = false
    
    @State var isShowingToast: Bool = false
    @State var toastMessasge: String = ""
    @State var toastError: Bool = false
    @State var showUser: Bool = false
    @State var showSubscribe: Bool = false
  
    
    @State var currentMonthName: String = ""
    @ObservedObject var transactionData = TransactionData()
    
  
    
    func onAppear() {
        
        self.expenses = abs(transactionData.fetchExpenses())
        self.incomes = transactionData.fetchIncomes()
       
    }

    var body: some View {


            VStack(spacing: 0) {
            
                
                ForEach(self.cardsFetch.indexed(), id: \.1.id) { index, card in
                    
                    if(card.name == "Month Available Balance") {
                        
//                        if(card.visible == true && settings.showMonthBalance == true) {
                         
//                            MonthBalanceView(totalAccounts: self.$totalAccounts, totalGoalAccounts: self.$totalGoalAccounts, totalGoals: self.$totalGoals, totalPayments: self.$totalPayments, totalBudgets: self.$totalBudgets, totalPurchases: self.$totalPurchases, incomes: self.$incomes, expenses: self.$expenses, hideData: self.$hideData)
//                                .padding(.top, 10)

//                             Spacer()
                        
//                        }
                    }
                    
                    if(card.name == "Accounts") {
                        
                        if(card.visible == true) {
                            AccountListView(totalAccounts: self.$totalAccounts, totalGoalAccounts: self.$totalGoalAccounts, incomes: self.$incomes, expenses: self.$expenses, hideData: self.$hideData, isShowingToast: $isShowingToast, toastMessasge: $toastMessasge, toastError: self.$toastError, showSubscribe: self.$showSubscribe)
                                .padding(.top, 10)

                             Spacer()
                        }
                       
                    }
                    
                    if(card.name == "Investments") {
                        
                        if(card.visible == true) {
//                            InvestmentListView(totalAccounts: self.$totalAccounts, totalGoalAccounts: self.$totalGoalAccounts, incomes: self.$incomes, expenses: self.$expenses, hideData: self.$hideData, isShowingToast: $isShowingToast, toastMessasge: $toastMessasge, toastError: self.$toastError, showSubscribe: self.$showSubscribe, showTutorialBank: $showTutorialBank)
//                                .padding(.top, 10)

                             Spacer()
                        }
                       
                    }
                    
                    if(card.name == "Goals") {
                        
                        if(card.visible == true) {
//                            GoalListView(totalGoals: self.$totalGoals, hideData: self.$hideData, isShowingToast: $isShowingToast, toastMessasge: $toastMessasge, toastError: self.$toastError,  showSubscribe: self.$showSubscribe)
//                               .padding(.top, 10)


                           Spacer()
                        }
                       
                    }
                    
                    if(card.name == "Budgets") {
                        
                        if(card.visible == true) {
//                            BudgetListView(totalBudgets: self.$totalBudgets, incomes: self.$incomes, expenses: self.$expenses, hideData: self.$hideData,isShowingToast: $isShowingToast, toastMessasge: $toastMessasge, toastError: self.$toastError,  showSubscribe: self.$showSubscribe, showTutorialBudget: $showTutorialBudget, totalAccounts: self.$totalAccounts, totalGoalAccounts: self.$totalGoalAccounts)
//                                .padding(.top, 10)

                            Spacer()
                        }
                       
                    }
                    
                    if(card.name == "Payments") {
                        
                        if(card.visible == true) {
//                            PaymentListView(totalPayments: self.$totalPayments, incomes: self.$incomes, expenses: self.$expenses, hideData: self.$hideData,isShowingToast: $isShowingToast, toastMessasge: $toastMessasge, toastError: self.$toastError,  showSubscribe: self.$showSubscribe, showTutorialPayment: $showTutorialPayment, totalAccounts: self.$totalAccounts, totalGoalAccounts: self.$totalGoalAccounts)
//                                .padding(.top, 10)

                            Spacer()
                        }
                        
                       
                    }
                    
                    if(card.name == "Purchases") {
                        
                        if(card.visible == true) {
//                            PurchaseListView(totalPurchases: self.$totalPurchases, incomes: self.$incomes, expenses: self.$expenses, hideData: self.$hideData,isShowingToast: $isShowingToast, toastMessasge: $toastMessasge, toastError: self.$toastError,  showSubscribe: self.$showSubscribe, totalAccounts: self.$totalAccounts, totalGoalAccounts: self.$totalGoalAccounts)
//                                .padding(.top, 10)

                            Spacer()
                        }
                        
                       
                    }
                    
                    if(card.name == "Cars") {
                        
                        if(card.visible == true) {
//                            CarListView(isShowingToast: $isShowingToast, toastMessasge: $toastMessasge, toastError: self.$toastError, showSubscribe: self.$showSubscribe)
//                                .padding(.top, 10)
                            
                            Spacer()
                        }
                       
                    }
                    
                    if(card.name == "Chart") {
                        
//                        if(card.visible == true) {
//                            BalanceChart()
//                                .padding(.top, 20)
//                                .frame(height: 350)
//                            
//                        }
                    }
                }
                
                    
                
//            GeometryReader { proxy in
//                Text("")
//                Text("")
//                Text("")
//                Text("")
//
//
//            }
//            .frame(height: ui.headerHeight)
//            .zIndex(1)

        ScrollView(.vertical, showsIndicators: false) {

           
        }
      
                
            }
//            .ignoresSafeArea()
//            .edgesIgnoringSafeArea([.top, .bottom])
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
