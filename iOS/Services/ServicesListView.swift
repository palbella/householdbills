//
//  AccountAddView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 9/1/21.
//

import SwiftUI
import CoreData


struct ServicesListView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var settings: UserSettings = UserSettings()
    @StateObject var ui: AppUI = AppUI()
    @Environment(\.managedObjectContext) private var viewContext
   
   
    @State var delete: Bool? = false
    @State var modal: Bool = false
    @State var unit: String = ""
    
    @State var isShowing: Bool = false
    @State var isShowingNew: Bool = false
    
    @State var isShowingToast: Bool = false
    @State var toastMessasge: String = ""
    @State var serviceSelected : ServiceModel = ServiceModel()
    
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
        var serviceFetchResult: FetchedResults<CarService>
    
    @Binding var showSubscribe: Bool
    @Binding var isShowingCar: Bool
    
    init(showSubscribe: Binding<Bool>, isShowingCar: Binding<Bool>) {
        self._showSubscribe = showSubscribe
        self._isShowingCar = isShowingCar
        UINavigationBar.appearance().isTranslucent = false
        
       }
    
    func onAppear () {
        UIApplication.shared.endEditing()
        self.unit = settings.unit
    }

    var body: some View {
       
//        NavigationView { issue on textbox

            VStack {
                
                HeaderTabView(title: "Car Services")
                
            ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                
   
                
                Section(header:
                            HStack {
                                VStack{
                                  
                                Text("Car Services")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 15)
                                .padding(.leading, 10)
                                .padding(.bottom, 5)
                                .font(.system(size: 12))
                                .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                                }
                                Spacer()
                                
                                VStack {
                                   
                                    Button(action: {
                                        if(settings.subscribed || self.serviceFetchResult.count < 1) {
                                        self.serviceSelected = ServiceModel()
                                        self.unit = settings.unit
                                        self.isShowingNew = true
                                        self.delete = nil
                                        } else {
                                            self.isShowingCar = false
                                            self.showSubscribe = true
                                        }
                                    }) {
                                        
                                        CommandButton(content: "plus.circle")
                                    }
                                    .sheet(isPresented: self.$isShowingNew, onDismiss: {
                                     
                                      
                                                       if(self.$serviceSelected.name.wrappedValue != "") {
                                                        addService(service: self.$serviceSelected.wrappedValue)
                                                       }
                                            

                                        }) {
                                        ServiceAddUpdateView(service: self.$serviceSelected, unit: self.$unit, modal: self.$isShowingNew, delete: self.$delete)
                                        
                                    }
                                    .frame(width: 15, height: 15)
                                    .padding(.leading, 10)
                                    .padding(.trailing, 17)
                                    .padding(.bottom, 12)
                                }
                               
                            }
                          
                            
                ) {

                    Divider()
                    
                  
                    
                   
                    ForEach(self.serviceFetchResult.indexed(), id: \.1.id) { index, item in


                                                                  Button(action: {
                                                                      if(settings.subscribed || index < 1) {
                                                                    self.serviceSelected = map(service: item)
                                                                      self.delete = false
                                                                    self.unit = settings.unit
                                                                      self.isShowing = true
                                                                      } else {
                                                                          self.isShowingCar = false
                                                                          self.showSubscribe = true
                                                                      }
                                                                  }) {

                                                                      VStack (spacing: 0) {
                                                                          HStack (spacing: 0) {
                                                                            Icon(content: "car", color: Color.yellow).padding(5).padding(.leading, 5).padding(.trailing, 5)

                                                                              VStack (spacing: 0) {

                                                                              HStack (spacing: 0) {
                                                                                Text(item.name!)
                                                                              .font(.system(size: 15))
                                                                              .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)

                                                                                Spacer()


                                                                                VStack(alignment: .trailing, spacing: 0) {
                                                                                    Text(settings.unit + String(item.amount)).padding(5)
                                                                                        .foregroundColor(colorScheme != .dark ? ui.lightItemFontColor: ui.darkItemFontColor)
                                                                              .font(.system(size: 13))
                                                                                        .multilineTextAlignment(.trailing)


                                                                                    Text("Months " + String(item.months)).padding(.leading, 5).padding(.trailing, 5).padding(.bottom, 5)
                                                                                        .foregroundColor(colorScheme != .dark ? ui.lightCommandFontColor: ui.darkCommandFontColor)
                                                                                        .multilineTextAlignment(.trailing)
                                                                                  .font(.system(size: 10))
                                                                                }
                                                                                .frame(width: 180, alignment: .trailing)
                                                                              }



                                                                              }
                                                                      }
                                                                      .frame(maxWidth: .infinity)

                                                                      }

                                                                  }
                                                                  .sheet(isPresented: self.$isShowing, onDismiss: {


                                                                    if(self.delete == true) {
                                                                          deleteService(service: self.$serviceSelected.wrappedValue)
                                                                      } else {
                                                                          updateService(service: self.$serviceSelected.wrappedValue)
                                                                      }

                                                                  }) {

                                                                    ServiceAddUpdateView(service: self.$serviceSelected, unit: self.$unit, modal: self.$isShowing, delete: self.$delete)



                                                }


                                          }
                                                          .background(colorScheme != .dark ? ui.lightItemBackgroundColor: ui.darkItemBackgroundColor)


                   
                 
                    
          
            }
            
         
                Spacer()
         
        }
         
            }
            
            }
//            .padding(.top, 40)
//            .navigationBarTitle("Back")
            .background(colorScheme != .dark ? ui.lightBackgroundColor: ui.darkBackgroundColor)
//            .navigationBarTitleDisplayMode(.inline)
            .background(NavigationConfigurator { nc in
                let color = colorScheme != .dark ? Color.white: ui.darkBackgroundColor
                            nc.navigationBar.barTintColor = UIColor(color)
                        })
//            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    Text("Car Services")
//                        .font(ui.title)
//                        .accessibilityAddTraits(.isHeader)
//                        .foregroundColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
//
//
//                }
//            }
            .onAppear {
                self.onAppear()
            }
        
//    }
//    .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
       
    }
    
    

    
    private func addService(service: ServiceModel)
    {

            withAnimation {
               
                let newService = CarService(context: viewContext)
                newService.id = UUID()
                newService.name = service.name
                newService.amount = service.amount
                newService.months = service.months


      SaveContext()
            }

    }

    private func updateService(service: ServiceModel)
    {


        do {
                let request: NSFetchRequest<CarService> = CarService.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", service.id as CVarArg)

                let savedService = try  self.viewContext.fetch(request)[0]

            savedService.name = service.name
            savedService.amount = service.amount
            savedService.months = service.months



        } catch {
            print(error)
        }

      SaveContext()


    }
    
    private func deleteService(service: ServiceModel)
    {
            withAnimation {

                let request: NSFetchRequest<CarService> = CarService.fetchRequest()

                    do {
                        let savedServices = try  self.viewContext.fetch(request)

                        for item in savedServices {
                            self.viewContext.delete(item)
                        }
                        try self.viewContext.save()
                    } catch {
                        print(error)
                    }

            }
SaveContext()


    }
    
    private func SaveContext () {
    do {

  try viewContext.save()


        }


    catch {

    }
    }

    private func map(service: CarService) -> ServiceModel
    {
        var serviceModel = ServiceModel()

        serviceModel.id = service.id!
        serviceModel.name = service.name ?? ""
        serviceModel.months = service.months
        serviceModel.amount = service.amount


        return serviceModel
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
