//
//  DashboardBodyView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI
import CoreData


struct DashboardBodyView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "order", ascending: true)])
    var cardsFetch: FetchedResults<Card>
    
    @ObservedObject var paymentData = PaymentData()
    
    @Binding var totalAccounts: Double
    @Binding var totalGoalAccounts: Double
    @Binding var totalGoals: Double
    @Binding var totalPayments: Double
    @Binding var totalBudgets: Double
    @Binding var totalPurchases: Double
    @Binding var incomes: Double
    @Binding var expenses: Double
    
    @Binding var hideData: Bool
    @State var monthChange: Bool = false
    @State var nextMonth: Date? = Date()
    @State var nextMonthName: String = ""
    
    @State var tutorial: TutorialData = TutorialData()
    
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    @Binding var isShowingPopup: Bool
    @Binding var popupMessasge: String
    @Binding var popupTitle: String
    @Binding var popupImage: String
    
    
    @Binding var currentMonthName: String
    
    @State var showConfirmBalance: Bool = false
   
    
    @Binding var showSubscribe: Bool
    
    @State var showTutorialBank: Bool = false
    @State var showTutorialBudget: Bool = false
    @State var showTutorialPayment: Bool = false
    
    func onAppear() {
     
        self.setMonthName()
        self.setMonthBalance()
        self.showTutorial()
        
    }
    
    var body: some View {
        
        VStack {
            
            if(monthChange) {
                
                Button(action: {
                    self.showConfirmBalance = true
                }) {
                VStack (spacing: 0) {
                    HStack (spacing: 0) {
                        
                        VStack (alignment: .leading, spacing: 0) {
                          Text(LocalizedStringKey("Close balance month ").toString() + currentMonthName)
                                .padding(.leading, 10)
                                .padding(.top, 10)
                                .padding(.bottom, 1)
                        .font(.system(size: 15))
                        .foregroundColor(Color.white)
                   
                            
                            Text(LocalizedStringKey("Open balance month ").toString() + nextMonthName)
                                  .padding(.leading, 10)
                                  .padding(.bottom, 10)
                                  .padding(.top, 2)
                          .font(.system(size: 15))
                          .foregroundColor(Color.white)
                     
                        }
                        
                        Spacer()
                        Icon(content: "greaterthan", color: .white, fontColor: ui.lightPrimaryColor).padding(5).padding(.leading, 5).padding(.trailing, 5)
                            .foregroundColor(ui.lightPrimaryColor)
                }
                }
                .background(ui.lightPrimaryColor)
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
            
            ForEach(self.cardsFetch.indexed(), id: \.1.id) { index, card in
                
                if(card.name == "Month Available Balance") {
                    
                    if(card.visible == true && settings.showMonthBalance == true) {
                     
                        MonthBalanceView(totalAccounts: self.$totalAccounts, totalGoalAccounts: self.$totalGoalAccounts, totalGoals: self.$totalGoals, totalPayments: self.$totalPayments, totalBudgets: self.$totalBudgets, totalPurchases: self.$totalPurchases, incomes: self.$incomes, expenses: self.$expenses, hideData: self.$hideData)
                            .padding(.top, 10)

                         Spacer()
                    
                    }
                }
                
                if(card.name == "Accounts") {
                    
                    if(card.visible == true) {
                        AccountListView(totalAccounts: self.$totalAccounts, totalGoalAccounts: self.$totalGoalAccounts, incomes: self.$incomes, expenses: self.$expenses, hideData: self.$hideData, isShowingToast: $isShowingToast, toastMessasge: $toastMessasge, toastError: self.$toastError, showSubscribe: self.$showSubscribe, showTutorialBank: $showTutorialBank)
                            .padding(.top, 10)

                         Spacer()
                    }
                   
                }
                
                if(card.name == "Investments") {
                    
                    if(card.visible == true) {
                        InvestmentListView(totalAccounts: self.$totalAccounts, totalGoalAccounts: self.$totalGoalAccounts, incomes: self.$incomes, expenses: self.$expenses, hideData: self.$hideData, isShowingToast: $isShowingToast, toastMessasge: $toastMessasge, toastError: self.$toastError, showSubscribe: self.$showSubscribe, showTutorialBank: $showTutorialBank)
                            .padding(.top, 10)

                         Spacer()
                    }
                   
                }
                
                if(card.name == "Goals") {
                    
                    if(card.visible == true) {
                        GoalListView(totalGoals: self.$totalGoals, hideData: self.$hideData, isShowingToast: $isShowingToast, toastMessasge: $toastMessasge, toastError: self.$toastError,  showSubscribe: self.$showSubscribe)
                           .padding(.top, 10)


                       Spacer()
                    }
                   
                }
                
                if(card.name == "Budgets") {
                    
                    if(card.visible == true) {
                        BudgetListView(totalBudgets: self.$totalBudgets, incomes: self.$incomes, expenses: self.$expenses, hideData: self.$hideData,isShowingToast: $isShowingToast, toastMessasge: $toastMessasge, toastError: self.$toastError,  showSubscribe: self.$showSubscribe, showTutorialBudget: $showTutorialBudget, totalAccounts: self.$totalAccounts, totalGoalAccounts: self.$totalGoalAccounts)
                            .padding(.top, 10)

                        Spacer()
                    }
                   
                }
                
                if(card.name == "Payments") {
                    
                    if(card.visible == true) {
                        PaymentListView(totalPayments: self.$totalPayments, incomes: self.$incomes, expenses: self.$expenses, hideData: self.$hideData,isShowingToast: $isShowingToast, toastMessasge: $toastMessasge, toastError: self.$toastError,  showSubscribe: self.$showSubscribe, showTutorialPayment: $showTutorialPayment, totalAccounts: self.$totalAccounts, totalGoalAccounts: self.$totalGoalAccounts)
                            .padding(.top, 10)

                        Spacer()
                    }
                    
                   
                }
                
                if(card.name == "Purchases") {
                    
                    if(card.visible == true) {
                        PurchaseListView(totalPurchases: self.$totalPurchases, incomes: self.$incomes, expenses: self.$expenses, hideData: self.$hideData,isShowingToast: $isShowingToast, toastMessasge: $toastMessasge, toastError: self.$toastError,  showSubscribe: self.$showSubscribe, totalAccounts: self.$totalAccounts, totalGoalAccounts: self.$totalGoalAccounts)
                            .padding(.top, 10)

                        Spacer()
                    }
                    
                   
                }
                
                if(card.name == "Cars") {
                    
                    if(card.visible == true) {
                        CarListView(isShowingToast: $isShowingToast, toastMessasge: $toastMessasge, toastError: self.$toastError, showSubscribe: self.$showSubscribe)
                            .padding(.top, 10)
                        
                        Spacer()
                    }
                   
                }
                
                if(card.name == "Chart") {
                    
                    if(card.visible == true) {
                        BalanceChart()
                            .padding(.top, 20)
                            .frame(height: 350)
                        
                    }
                }
            }
            
                
Divider()
            
        }
        .onAppear(){
            self.onAppear()
            
        }
        .alert(isPresented: $showConfirmBalance, content: { confirmBalance })
        .onChange(of: self.showTutorialBank, perform: { value in showTutorial() })
        .onChange(of: self.showTutorialBudget, perform: { value in showTutorial() })
        .onChange(of: self.showTutorialPayment, perform: { value in showTutorial() })
    
        
    }
    
    var confirmBalance: Alert {
        
        var text = LocalizedStringKey("Are you sure you want to change the month?").toString()
        
        if(paymentData.hasUnpaidPayments()) {
            text = LocalizedStringKey("Current month has payments pending to be paid... are you sure you still want to change the month?").toString() 
        }
        
        return Alert(title: Text("New Month Balance"), message: Text(text),
            primaryButton: .default (Text("Yes")) {
            MonthBalance().run(totalBalance: self.totalAccounts, dayChangeMonth: settings.dayChangeMonth)
            self.setMonthName()
            self.setMonthBalance()
            },
            secondaryButton: .cancel(Text("No"))
        )
    }
    
    func showTutorial() {
        
            self.showTutorialBank = tutorial.needTutorial(name: "dashboard", tutorialStep: 0)
            self.popupTitle = LocalizedStringKey("Tutorial").toString() 
            self.popupMessasge = LocalizedStringKey("Click on the bank account and set your current bank balance.").toString()
            self.popupImage = "tutorial1"
            self.isShowingPopup = self.showTutorialBank
        
        
        if( self.showTutorialBank == false) {
            self.showTutorialBudget = tutorial.needTutorial(name: "dashboard", tutorialStep: 1)
            self.popupTitle = LocalizedStringKey("Tutorial").toString()
            self.popupMessasge = LocalizedStringKey("Set how much do you want to spend this month in bars and restaurants.").toString()
            self.popupImage = "tutorial2"
            self.isShowingPopup = self.showTutorialBudget
        }
        
        if( self.showTutorialBank == false  && self.showTutorialBudget == false) {
            self.showTutorialPayment = tutorial.needTutorial(name: "dashboard", tutorialStep: 2)
            self.popupTitle = LocalizedStringKey("Tutorial").toString()
            self.popupMessasge = LocalizedStringKey("Do not forget to pay your bills, create a new payment, you will be able to mark as paid later.").toString()
            self.popupImage = "tutorial3"
            self.isShowingPopup = self.showTutorialPayment
        }
        
        if( self.showTutorialBank == false  && self.showTutorialBudget == false && self.showTutorialPayment == false) {
        }
        
    }
    
    func setMonthName () {
        let monthRequest: NSFetchRequest<Month> = Month.fetchRequest()
        monthRequest.predicate = NSPredicate(format: "current = true")
        
        do {
            let currentMonth = try viewContext.fetch(monthRequest)[0]
            self.currentMonthName = currentMonth.name! //getMonthName(monthNumber: currentMonth.month)
        } catch {
            
        }
    }
    
    func setMonthBalance () {
        let monthRequest: NSFetchRequest<Month> = Month.fetchRequest()
        monthRequest.predicate = NSPredicate(format: "current = true")
        
        let dateFormarterLabel = DateFormatter()
        dateFormarterLabel.dateFormat = "MMM y"
        
        do {
            let currentMonth = try viewContext.fetch(monthRequest)[0]
            
            var dateComponent = DateComponents()
            dateComponent.month = 1
            
           
            
            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let toDateFormat = dateFormatter.date(from:
                                                String(currentMonth.timestamp!.get(.year)) + "-" +
                                                String(currentMonth.timestamp!.get(.month)) + "-" +
                                                String(settings.dayChangeMonth))
            
            let calendar = Calendar(identifier: .gregorian)
            var components = calendar.dateComponents([.year, .month], from: currentMonth.timestamp!)

            let startOfMonth =  calendar.date(from: components)!
            
             components = DateComponents()
                    components.month = 1
                    components.second = -1
                    let endMonth = Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
            
            
            let toDate : NSDate = toDateFormat != nil ? toDateFormat! as NSDate : endMonth as NSDate
            
//            print(toDate as Date)
//            print(Date().get(.month))
//            print(currentMonth.timestamp?.get(.month))
//            print(Date().get(.year))
//            print(currentMonth.timestamp?.get(.year))
            if(Date() > toDate as Date ||
               (Date().get(.month) > (currentMonth.timestamp?.get(.month))! && Date().get(.year) == (currentMonth.timestamp?.get(.year))!) ||
               Date().get(.year) > (currentMonth.timestamp?.get(.year))!) {
                self.monthChange = true
            } else {
                self.monthChange = false
            }
            
            if(self.monthChange) {
                nextMonth = Calendar.current.date(byAdding: dateComponent, to: Date())
                nextMonthName = dateFormarterLabel.string(from: nextMonth!)
            } else {
                nextMonth = Date()
                nextMonthName = dateFormarterLabel.string(from: nextMonth!)
            }
            
        } catch {
            
        }
    }
}


//#if DEBUG
//struct DashboardBodyView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//       
//            DashboardBodyView().environmentObject(UserSettings())
//                .environmentObject(AppUI())
//        
//    }
//}
//#endif

