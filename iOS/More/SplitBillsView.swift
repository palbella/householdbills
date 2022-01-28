//
//  AccountAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/1/21.
//

import SwiftUI
import CoreData


struct SplitBillsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
   
  
    @State var name: String = ""
    @State var amount: NSNumber? = nil
    @StateObject var people : GetSplitBills = GetSplitBills()
    
    @State var viewRefresh : Int = 0
    @State var refresh: Bool = false
    
    @Binding var modal: Bool
    @Binding var save: Bool
 
    @State var showTutorialInfo: Bool = true
    @State var tutorial: TutorialData = TutorialData()
    
    @State var isShowingPopup: Bool = false
    @State var popupMessasge: String = ""
    @State var popupTitle: String = ""
    @State var popupImage: String = ""

    var body: some View {
       
        VStack(spacing: 0) {

            ZStack {
                VStack(spacing: 0) {
            HeaderTabView(title: "Split Bills", modal: $modal, save: $save)
            HeaderTabTitleView(title: "Split Bills")
            
            ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                
                VStack {
                  
                   
                    CustomTextfield(label: "Name", text: $name, keyType: UIKeyboardType.alphabet, textAlignment: .right,
                                    maxLength: 10)
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 10))
                        .frame(height: 35)
                        .background(colorScheme != .dark ? Color(UIColor.white): Color(UIColor.systemGray2))
                        .cornerRadius(5)
                        .shadow(color: .gray, radius: 0.5)
                               .padding()
                               .padding(.bottom, 0)
                               .padding(.top, 0)
                  
                     
                    
                    CurrencyField("Amount", value: $amount, foregroundColor: UIColor(Color(UIColor.lightGray)),
                                  maxLength: 10)
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 10))
                        .accentColor(.red)
                        .frame(height: 35)
                        .background(colorScheme != .dark ? Color(UIColor.white): Color(UIColor.systemGray2))
                        .cornerRadius(5)
                        .shadow(color: .gray, radius: 0.5)
                               .padding()
                               .padding(.bottom, 0)
                               .padding(.top, 0)
                      
                    
                    Spacer()
                    
                    HStack {
                        
                      

                        Button(action: {
                            addPerson()
                            UIApplication.shared.endEditing()
                        }) {
                                        HStack {
                                            Image(systemName: "plus.circle")
                                                .font(.title)
                                        }
                                    }
                        .buttonStyle(AppButtonStyle())



                        Button(action: {
                            deletePerson()
                            UIApplication.shared.endEditing()
                        }) {
                                        HStack {
                                            Image(systemName: "trash.circle")
                                                .font(.title)
                                        }
                                    }
                        .buttonStyle(AppButtonStyle())
                     
                        
                        Button(action: {
                            clearList()
                            UIApplication.shared.endEditing()
                        }) {
                                        HStack {
                                            Image(systemName: "clear")
                                                .font(.title)
                                        }
                                    }
                        .buttonStyle(AppButtonStyle())

           
                   
                    
                
                   
                   
               
                }
                
                Section(header:
                            HStack {
                                VStack (spacing: 0) {
                                  
                                Text("People")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 0)
                                .padding(.leading, 10)
                                .font(.system(size: 12))
                                .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                                }
                    Spacer()
                                
                               
                            }
                         
                          
                            
                ) {
                    
                    VStack(spacing: 0) {
Spacer()
                    Divider()
                  
                    
                        ForEach(self.people.items.indexed(), id: \.1.id) { index, item in

                            let percent = item.result < 0 ? (100 - (abs(item.amount) * 100 / item.total)) : item.result * 100 / item.total
                            let percentPositive = item.result >= 0
                            var iconColor = self.people.items[index].selected == true ? Color.blue: Color.gray

                        

                                
                                HStack (spacing: 0) {
                                    
                                    Button(action: {
                                        self.people.items[index].selected.toggle()
                                        self.viewRefresh = self.viewRefresh + 1
                                        iconColor = self.people.items[index].selected == true ? Color.blue: Color.gray
                                    }) {
                                    Icon(content: "person.fill", color: iconColor).padding(5).padding(.leading, 5).padding(.trailing, 5)
                                    }
                                    Text(String(viewRefresh))
                                        .frame(width: 0)
                                   
                                      
                                    VStack (spacing: 0) {
                                        Spacer()
                                        HStack (spacing: 0) {
                                            Text(self.people.items[index].name)
                                            .font(.system(size: 15))
                                            .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)
                                            .frame(alignment: .leading)
                                        
                                        Spacer()
                                            ProgressView(settings.symbol + " " + String(format: "%.2f", item.amount), value: percent, total: 100)
                                            .font(.system(size: 10))
                                            .foregroundColor(colorScheme != .dark ? Color(UIColor.darkGray): ui.darkCommandFontColor)
                                            .accentColor(percentPositive ? Color.green : Color.red)
                                            .frame(width: 60)
                                        
                                         
                                                Text(settings.symbol + " " + String(format: "%.2f", item.result)).padding(5).padding(.leading, 5).padding(.trailing, 5)
//                                                    .foregroundColor(fontColor)
                                        .font(.system(size: 15))
                                        .frame(minWidth: 130, alignment: .trailing)
                                          
                                            
                                  

                                        
                                    }
                                        Spacer()
                                     
                                        
                                    }
                                 
                                  

                                    
                            }
                          
                                

                            
                            .frame(height: ui.itemHeight)
                            .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)

                                              }
                                              

                        Spacer()
          
            }
                }
         
             
         
        }
         
            }
            .padding(.top, 0)
            }
           
        }
                PopUpWindow(isShowingPopup: $isShowingPopup, popupTitle: $popupTitle, popupMessasge: $popupMessasge, popupImage: $popupImage)
        
    }
        .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
        

    .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
       
    }
        .onAppear(){
            showTutorial()
        }
    }
    
    
    func showTutorial() {
        
        self.showTutorialInfo = tutorial.needTutorial(name: "splitbills", tutorialStep: 0)
        if( self.showTutorialInfo == true) {
            self.popupTitle = LocalizedStringKey("Tutorial").toString()
            self.popupMessasge = LocalizedStringKey("tutorial9-planning").toString()
            self.popupImage = "tutorial9"
            self.isShowingPopup = self.showTutorialInfo
            tutorial.saveTutorial(name: "splitbills", tutorialStep: 0)
        }
    
        
    }
    
    func addPerson()
    {

            withAnimation {
               
                if(self.$name.wrappedValue != "" && self.$amount.wrappedValue != nil) {
                    
                    
                    
                    
                    
                    var person = SplitBillsModel()
                  
                        person.name = self.$name.wrappedValue
                        person.amount = Double(truncating: self.$amount.wrappedValue!)
                        person.result = 10
                        
                    
                        self.people.items.append(person)
                    self.name = ""
                    self.amount = nil
                    
                    calc ()
                    
                }

          
     
            }

    }

    
    func deletePerson()
    {
            withAnimation {

                var done: Bool = false
                while(done == false) {
                    var index: Int?
                for i in 0..<self.people.items.count {
             
                    if(self.people.items[i].selected) {
                       index = i
                    }
                        }
                    
                    if(index != nil) {
                        self.people.items.remove(at: index!)
                    } else {
                        done = true
                    }
                     
                }
                
                calc ()

            }



    }
    
    func clearList()
    {

            withAnimation {
               
                self.people.items.removeAll()
                self.name = ""
                self.amount = nil
     
            }

    }
    
    func calc () {
        
        var total : Double = 0
        for i in 0..<self.people.items.count {
            total = total + self.people.items[i].amount
        }
       
        for i in 0..<self.people.items.count {
            self.people.items[i].result = self.people.items[i].amount - (total / Double(self.people.items.count))
            self.people.items[i].total = (total / Double(self.people.items.count))
        }
    }
    
  
    
    
}




