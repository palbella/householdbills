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
    @StateObject var settings: UserSettings = UserSettings()
    @StateObject var ui: AppUI = AppUI()
    @Environment(\.managedObjectContext) private var viewContext
   
  
    @State var name: String = ""
    @State var amount: NSNumber? = 0
    @State var people : GetSplitBills = GetSplitBills()
    
    @State var viewRefresh : Int = 0
 

    var body: some View {
       
        VStack(spacing: 0) {

            HeaderTabView(title: "Split Bills")
            
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
//                            unlock(pin: pin, password: password)
                            UIApplication.shared.endEditing()
                        }) {
                                        HStack {
                                            Image(systemName: "plus.circle")
                                                .font(.title)
                                        }
                                    }
                        .buttonStyle(AppButtonStyle())



                        Button(action: {
//                            lock(pin: pin, password: password)
                            UIApplication.shared.endEditing()
                        }) {
                                        HStack {
                                            Image(systemName: "trash.circle")
                                                .font(.title)
                                        }
                                    }
                        .buttonStyle(AppButtonStyle())
                     
                        
                        Button(action: {
//                            password = ""
//                            pin = ""
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
                                VStack{
                                  
                                Text("People")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 0)
                                .padding(.leading, 10)
                                .padding(.bottom, 5)
                                .font(.system(size: 12))
                                .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                                }
                                Spacer()
                                
                                VStack {
                                   
                                    ForEach(self.people.items.indexed(), id: \.1.id) { index, item in

                                        let percent = item.amount < item.result ? item.amount * 100 / item.result: 100
                                        var iconColor = self.people.items[index].selected == true ? Color.blue: Color.gray

                                        VStack (spacing: 0) {

                                            
                                            HStack (spacing: 0) {
                                                
                                                Button(action: {
                                                    self.people.items[index].selected.toggle()
                                                    self.viewRefresh = self.viewRefresh + 1
                                                    iconColor = self.people.items[index].selected == true ? Color.blue: Color.gray
                                                }) {
                                                Icon(content: "cart", color: iconColor).padding(5).padding(.leading, 5).padding(.trailing, 5)
                                                }
                                                Text(String(viewRefresh))
                                                    .frame(width: 0)
                                               
                                                  
                                                VStack (spacing: 0) {
                                                    Spacer()
                                                    HStack (spacing: 0) {
                                                        Text(item.name)
                                                        .font(.system(size: 15))
                                                        .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)
                                                        .frame(alignment: .leading)
                                                    
                                                    Spacer()
                                                        ProgressView(settings.symbol + " " + String(format: "%.2f", item.amount), value: percent, total: 100)
                                                        .font(.system(size: 10))
                                                        .foregroundColor(colorScheme != .dark ? Color(UIColor.darkGray): ui.darkCommandFontColor)
                                                        .frame(width: 60)
                                                    
                                                     
                                                            Text(settings.symbol + " " + String(format: "%.2f", abs(item.result))).padding(5).padding(.leading, 5).padding(.trailing, 5)
//                                                    .foregroundColor(fontColor)
                                                    .font(.system(size: 15))
                                                    .frame(minWidth: 130, alignment: .trailing)
                                                      
                                                        
                                              

                                                    
                                                }
                                                    Spacer()
                                                 
                                                    
                                                }
                                             
                                              

                                                
                                        }
                                            .padding(.top, 10)
                                            .padding(.bottom, 10)
                                            

                                        }
                                        


                                                          }
                                                           .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)

                                    
                                
                            
                                }
                               
                            }
                            .padding(.top, 10)
                          
                            
                ) {

                    Divider()
                    
                   
                 
          
            }
            
         
                Spacer()
         
        }
         
            }
            .padding(.top, 40)
            
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        
    }
        .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
        

    .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
       
    }
    }
    
    
    
    
    func addPerson()
    {

            withAnimation {
               
//                let newPassword = Password(context: viewContext)
//                newPassword.id = UUID()
//                newPassword.name = password.name
//                newPassword.password = passwordEncription.Entrypt(pin: String(password.code), password: password.password)
//

     
            }

    }

    
    func deletePerson()
    {
            withAnimation {

//                let request: NSFetchRequest<Password> = Password.fetchRequest()
//                request.predicate = NSPredicate(format: "id == %@", password.id as CVarArg)
//
//                    do {
//                        let savedPasswords = try  self.viewContext.fetch(request)
//
//                        for item in savedPasswords {
//                            self.viewContext.delete(item)
//                        }
//                        try self.viewContext.save()
//                    } catch {
//                        print(error)
//                    }

            }



    }
    
  
    
    
}




