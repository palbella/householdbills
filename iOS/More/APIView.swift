//
//  AccountAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/1/21.
//

import SwiftUI
import CoreData


struct APIView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
   
    
    @State private var selectedTab: Int = 0
    
    @Binding var modal: Bool
    @Binding var save: Bool
    @Binding var model: APIModel
    
    @State var apiTypes = GetAPI()
    @State var apiTypesIndex: Int = 0
    @State var apiTypesSelected: String? = "GET"
    
    @State var responseExample: String = "GET"
    @State var requestExample: String = "GET"
    
    init(modal: Binding<Bool>, save: Binding<Bool>, model: Binding<APIModel>) {
    
        self._modal = modal
        self._save = save
        self._model = model
        UINavigationBar.appearance().isTranslucent = false
        UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
       }
    
    func onAppear() {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = colorScheme != .dark ? .lightGray : .darkGray
        appearance.backgroundColor = colorScheme != .dark ? UIColor(Color.white): UIColor(ui.darkBackgroundColor)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
 

    var body: some View {
        
        NavigationView {
            VStack(spacing: 0) {
                
           
                    HeaderTabTitleView(title: "API")
            ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                
                VStack {
                           Picker("", selection: $selectedTab) {
                               Text("Stock").tag(0)
                               Text("Crypto").tag(1)
                               Text("Currency").tag(2)
                           }
                           .pickerStyle(SegmentedPickerStyle())

                           switch(selectedTab) {
                               case 0:
                               VStack {
                               ZStack {
                                           RoundedRectangle(cornerRadius: 8, style: .continuous)
                                               .fill(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
                                               .clipped()
                                               .shadow(color: colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor,radius: 1, x: 0, y: 0)
                                               .padding()

                                           VStack {
                                        
                                               PickerInput(iconContent: "", iconColor: .blue, label: "Type", placeholder: "Type", data: $apiTypes.items, value: $apiTypesSelected, index: $apiTypesIndex)
                                                   .onChange(of: apiTypesIndex, perform: { value in
                                                       if(apiTypesSelected != nil) {
                                                           model.type = apiTypesSelected!
                                                       }
                                                   })
                                                   .padding(.bottom, 5)
                                             
                                           }
                                           .frame(width: 250, height: 100)
                                           .multilineTextAlignment(.center)
                                       }
                                   
                                   if(model.type == "GET") {
                                   Section(header:
                                               HStack {
                                                   VStack{
                                                       Spacer()
                                                   Text("URL: https://url.example?symbol=$stock$")
                                                   .frame(maxWidth: .infinity, alignment: .leading)
                                                   .padding(.top, 10)
                                                   .padding(.leading, 20)
                                                   .padding(.bottom, 0)
                                                   .font(.system(size: 12))
                                                   .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                                                   }
                                                   Spacer()
                                                   
                                                  
                                               }
                                             
                                               
                                   ) {
                                   ZStack {
                                               RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                   .fill(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
                                                   .clipped()
                                                   .shadow(color: colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor,radius: 1, x: 0, y: 0)
                                                   .padding()

                                               VStack {
         
                                                   MultilineTextView(text: $model.api)
                                                       .frame(width: 250, height: 100)
                                                           .multilineTextAlignment(.trailing)
                                                 
                                               }

                                               .frame(width: 250, height: 150)
                                               .multilineTextAlignment(.center)
                                           }
                                   }
                                   if(model.type == "POST") {
                                   Section(header:
                                               HStack {
                                                   VStack{
                                                       Spacer()
                                                   Text("REQUEST")
                                                   .frame(maxWidth: .infinity, alignment: .leading)
                                                   .padding(.top, 10)
                                                   .padding(.leading, 20)
                                                   .padding(.bottom, 0)
                                                   .font(.system(size: 12))
                                                   .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                                                   }
                                                   Spacer()
                                                   
                                                  
                                               }
                                             
                                               
                                   ) {
                                   ZStack {
                                               RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                   .fill(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
                                                   .clipped()
                                                   .shadow(color: colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor,radius: 1, x: 0, y: 0)
                                                   .padding()

                                               VStack {
         
                                                   MultilineTextView(text: $model.request)
                                                       .frame(width: 250, height: 100)
                                                           .multilineTextAlignment(.trailing)
                                                 
                                               }

                                               .frame(width: 250, height: 150)
                                               .multilineTextAlignment(.center)
                                           }
                                   }
                                   }
                                   Section(header:
                                               HStack {
                                                   VStack{
                                                       Spacer()
                                                   Text("RESPONSE: [anyProperty][propertyPrice] or just [propertyPrice]")
                                                   .frame(maxWidth: .infinity, alignment: .leading)
                                                   .padding(.top, 10)
                                                   .padding(.leading, 20)
                                                   .padding(.bottom, 0)
                                                   .font(.system(size: 12))
                                                   .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                                                   }
                                                   Spacer()
                                                   
                                                  
                                               }
                                             
                                               
                                   ) {
                                   ZStack {
                                               RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                   .fill(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)
                                                   .clipped()
                                                   .shadow(color: colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor,radius: 1, x: 0, y: 0)
                                                   .padding()

                                               VStack {
         
                                                   MultilineTextView(text: $model.response)
                                                       .frame(width: 250, height: 100)
                                                           .multilineTextAlignment(.trailing)
                                                 
                                               }

                                               .frame(width: 250, height: 150)
                                               .multilineTextAlignment(.center)
                                           }
                                   }
                                   } else {
                                       CardMenu(prompt: "hammer", title: "Not supported yet")
                                   }
                               }
                               .padding(.top, 15)
                               case 1:
                               CardMenu(prompt: "hammer", title: "Not supported yet")
                               case 2:
                               CardMenu(prompt: "hammer", title: "Not supported yet")
                           default:
                               CardMenu(prompt: "metronome", title: "Something Went Wrong")
                           }
                       }
            
         
                Spacer()
         
        }
            .padding(.top, 0)
        
        }
           
            .background(NavigationConfigurator { nc in
                let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                            nc.navigationBar.barTintColor = UIColor(color)
                        })
            .navigationBarTitleDisplayMode(.inline)
            .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if(settings.fastApply == true) {
                    Text("API")
                        .font(ui.title)
                        .accessibilityAddTraits(.isHeader)
                        .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                  
                    if(settings.fastApply != true) {
                      
                                        Button("Done") {
                                         
                                                self.modal = false
                                                self.save = true
                                          
                                        }
                    }
                                    }
            }
            .onAppear(){
                self.onAppear()
            }
          
            }
        
    }
//    .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
    .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
       
    }
    
    
    
}


//#if DEBUG
//struct ServiceView_Previews: PreviewProvider {
//
//    static var viewContext = PersistenceController.preview.container.viewContext
//
//    static var previews: some View {
//
//        ServicecurrencyView(account: .constant(AccountModel()), modal: .constant(false), delete: .constant(false)).environmentObject(UserSettings())
//                .environmentObject(AppUI())
//                .environment(\.managedObjectContext, viewContext)
//
//    }
//}
//#endif
