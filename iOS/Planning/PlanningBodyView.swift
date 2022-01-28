//
//  DashboardBodyView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI
import CoreData

struct PlanningBodyView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isShowing: Bool = false
    @State var isShowingNew: Bool = false
    @State var delete: Bool = false
    @Binding var isShowingToast: Bool
    @Binding var toastMessasge: String
    @Binding var toastError: Bool
    @Binding var isShowingPopup: Bool
    @Binding var popupMessasge: String
    @Binding var popupTitle: String
    @Binding var popupImage: String
    
    let fetchRequest: NSFetchRequest<Settings> = Settings.fetchRequest()

    @State var totalPayments: Double = 0
    @State var totalBudgets: Double = 0
    @State var totalPurchases: Double = 0
    
    @State var showInfo: Bool = false
    @State var showSync: Bool = false
    
    @Binding var showSubscribe: Bool
    @State var animationStatus = false
    @State var showTutorialInfo: Bool = true
    
    @State var tutorial: TutorialData = TutorialData()
   
    
     
    func onAppear() {
        withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)){
                animationStatus.toggle()
        }
        
       
        self.showTutorial()
    }
    
    var body: some View {
        
        
        let labelColor = colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor
        let fontColor = colorScheme != .dark ? ui.lightFieldFontColor: ui.darkFieldFontColor
      
        VStack(spacing: 0) {
        Section(header:
                    HStack {
                        VStack{
                            Spacer()
                        Text("MONTHLY ESTIMATED INCOME")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 15)
                        .padding(.leading, 10)
                        .padding(.bottom, 5)
                        .font(.system(size: 12))
                        .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                        }
                        
                        
                       
                    }
                  
                    
        ){
        VStack(spacing: 0) {
            Spacer()
        Divider()
            DoubleInput(labelColor: labelColor, fontColor: fontColor, iconContent: "pencil", iconColor: .blue, label: "Estimated Income", value: $settings.estimatedMontlyIncomes)
                   .onChange(of: settings.estimatedMontlyIncomes, perform: { value in
                    do {
                    let savedSettings =  try viewContext.fetch(fetchRequest)
                        
                        if(savedSettings.count == 1) {
                            
                            savedSettings[0].monthIncome = settings.estimatedMontlyIncomes

                            SaveContext()
                        }
                       
                    } catch {
                        print(error)
                    }
                   })
            .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
       
            HStack (spacing: 0) {
                Text("   ")
                    .padding(.top, 15)
                    .padding(.bottom, 15)
                  
             
            Text("Unassigned Amount")
                .foregroundColor(labelColor)
                    
            Spacer()
                Text("\((settings.estimatedMontlyIncomes - totalPayments - totalBudgets), specifier: "%.2f")")
                .padding(5).padding(.leading, 5).padding(.trailing, 5)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                    
                
   
                
        }
            .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
           
            
            HStack (spacing: 0) {
                Spacer()
                
                Button(action: {
                    showInfo.toggle()
                    tutorial.saveTutorial(name: "planning", tutorialStep: 0)
                }) {
                    ZStack {
                        if(showTutorialInfo == true) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(animationStatus ? ui.darkCommandFontColor : ui.lightPrimaryColor)
                            .frame(width: 26, height: 26)
                        } else {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(ui.darkCommandFontColor)
                                .frame(width: 26, height: 26)
                        }
                        
                            Image(systemName: "info")
                            .foregroundColor(Color.white)
                                .font(.system(size: 15, weight: .heavy))
                        
                            
                    }
                    .padding(5).padding(.leading, 5).padding(.trailing, 5)
                        .padding(.top, 15)
                        .padding(.bottom, 15)
                   
                }

         

        }
            .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
            
            HStack{
            if(showInfo) {
            VStack (spacing: 0) {
                
                VStack (spacing: 0) {

        
                    Text("Monthly Planning")
                            .foregroundColor(ui.darkPrimaryColor)
                        .font(.system(size: 15))
                        .padding(.leading, 10)
                        .padding(.top, 10)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
        
                
                        Text("planning-info")
                        .padding(5).padding(.leading, 5).padding(.trailing, 5)
                        .multilineTextAlignment(.leading)
                            .font(.system(size: 12))
                            .frame(maxWidth: .infinity, alignment: .leading)
        
        
        
                }
                
            VStack (spacing: 0) {

    
                Text("Budgets")
                        .foregroundColor(ui.darkPrimaryColor)
                    .font(.system(size: 15))
                    .padding(.leading, 10)
                    .padding(.top, 10)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
    
            
                    Text("budget-info")
                    .padding(5).padding(.leading, 5).padding(.trailing, 5)
                    .multilineTextAlignment(.leading)
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
    
    
    
            }
            
            VStack (spacing: 0) {

            Text("Payments")
                    .foregroundColor(ui.darkPrimaryColor)
                .font(.system(size: 15))
                .padding(.leading, 10)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
          
                Text("payment-info")
                .padding(5).padding(.leading, 5).padding(.trailing, 5)
                .multilineTextAlignment(.leading)
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)

        }
            
            VStack (spacing: 0) {

            Text("Goals")
                    .foregroundColor(ui.darkPrimaryColor)
                .font(.system(size: 15))
                .padding(.leading, 10)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
         
                Text("goal-info")
                .padding(5).padding(.leading, 5).padding(.trailing, 5)
                .multilineTextAlignment(.leading)
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)


        }
            
            VStack (spacing: 0) {

            Text("Purchases")
                    .foregroundColor(ui.darkPrimaryColor)
                .font(.system(size: 15))
                .padding(.leading, 10)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
          
                Text("purchase-info")
                    .padding(5).padding(.leading, 5).padding(.trailing, 5).padding(.bottom, 10)
                .multilineTextAlignment(.leading)
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)


        }
            
              
              
            }
            
            }
                  
            }
            .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
            Divider()
            Spacer()
        
        }
      
       
        }
        
            PlanningBudgetBodyView(totalBudgets: self.$totalBudgets, isShowingToast: self.$isShowingToast, toastMessasge: self.$toastMessasge, toastError: self.$toastError, showSubscribe: self.$showSubscribe)
                .padding(.top, 10)
                .padding(.bottom, 20)
        PlanningPaymentBodyView(totalPayments: self.$totalPayments, isShowingToast: self.$isShowingToast, toastMessasge: self.$toastMessasge, toastError: self.$toastError, showSubscribe: self.$showSubscribe)
                .padding(.bottom, 20)
            PlanningPurchaseBodyView(totalPurchases: self.$totalPurchases, showSubscribe: self.$showSubscribe, isShowingToast: self.$isShowingToast, toastMessasge: self.$toastMessasge, toastError: self.$toastError)
                .padding(.bottom, 20)
           Spacer()
            
       
            
            VStack{
                Spacer()
                
                Button(action: {
                    if(settings.subscribed == true) {
                    MonthBalance(viewContext: viewContext).syncMonth()
                    self.toastMessasge = "Month Syncronized!"
                    self.toastError = false
                    self.isShowingToast = true
                    } else {
                        self.showSubscribe = true
                    }
                }) {
                    HStack {
                        Text("Syncronize with current month")
                    }
                    .padding()
                    .frame(width: 230, height: 30)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(ui.lightCommandFontColor)
                    .cornerRadius(5)
                    .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(ui.lightCommandFontColor, lineWidth: 2)
                            )
                }.padding(.bottom, 40)
                    .padding(.top, 20)
                
            }
            .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
           

        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear() {
            self.onAppear()
        }
       
       
    }
    
    func showTutorial() {
        
        self.showTutorialInfo = tutorial.needTutorial(name: "planning", tutorialStep: 0)
        
        
        if( self.showTutorialInfo == false) {
            self.showSync = tutorial.needTutorial(name: "planning", tutorialStep: 1)
            self.popupTitle = LocalizedStringKey("Tutorial").toString()
            self.popupMessasge = LocalizedStringKey("tutorial4-planning").toString()
            self.popupImage = "tutorial4"
            self.isShowingPopup = self.showSync
            tutorial.saveTutorial(name: "planning", tutorialStep: 1)
        }
        
    }
    
    private func SaveContext () {
    do {

  try viewContext.save()
        

        }
                            
    
    catch {
      
    }
    }
    
}





//#if DEBUG
//struct PlanningBodyView_Previews: PreviewProvider {
//    
//    static var viewContext = PersistenceController.preview.container.viewContext
//
//    static var previews: some View {
//        PlanningBodyView().environmentObject(UserSettings())
//            .environmentObject(AppUI())
//            .environment(\.managedObjectContext, viewContext)
//    }
//}
//#endif
