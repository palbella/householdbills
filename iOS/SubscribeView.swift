//
//  DashboardBodyView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 8/17/21.
//

import SwiftUI

struct SubscribeModel {
    var id: Int
    var image: String
    var titleText: String
    var descriptionText: String
    var showButton: Bool?
}

struct SubscribeView: View {
    @EnvironmentObject var ui: AppUI
    @Environment(\.presentationMode) var presentationMode
  
    var carusel: [SubscribeModel] = [
        SubscribeModel(id: 1, image: "welcome1", titleText: LocalizedStringKey("WelcomeTitle1").toString(), descriptionText: LocalizedStringKey("WelcomeDescription1").toString()),
        SubscribeModel(id: 2, image: "subscribe2", titleText: LocalizedStringKey("WelcomeTitle2").toString(), descriptionText: LocalizedStringKey("WelcomeDescription2").toString()),
        SubscribeModel(id: 3, image: "subscribe3", titleText: LocalizedStringKey("WelcomeTitle3").toString(), descriptionText: LocalizedStringKey("WelcomeDescription3").toString()),
        SubscribeModel(id: 4, image: "subscribe4", titleText: LocalizedStringKey("WelcomeTitle4").toString(), descriptionText: LocalizedStringKey("WelcomeDescription4").toString()),
        SubscribeModel(id: 5, image: "subscribe5", titleText: LocalizedStringKey("WelcomeTitle5").toString(), descriptionText: LocalizedStringKey("WelcomeDescription5").toString(), showButton: true)
    ]
    
    func onAppear() {
   
    }
    
    var body: some View {
        
        
        GeometryReader { geometry in
            VStack (alignment: .center){
                HStack {
                    Image(systemName: "house")
                    .resizable()
                    .frame(width: 15, height: 13)
                    .foregroundColor(Color.black)
                    
                    Text("Household Bills")
                        .font(.system(size: 12))
                        .foregroundColor(Color.black)

                }.padding(.top, 70)
                .padding(.bottom, 10)
           
                .frame(maxWidth: .infinity)
                Text("Subscribe")
                    .font(.title)
                    .font(.system(size: 14, weight: .bold, design: Font.Design.default))
                    .padding(.bottom, 0)
                
                Spacer()
                WelcomeScrollView(axis: .horizontal, numberOfPages: self.carusel.count, pagingEnabled: true, pageControlEnabled: geometry.size.height > 700, hideScrollIndicators: true, currentPageIndicator: .black, pageIndicatorTintColor: .white) {
                            HStack(spacing: 0) {
                                ForEach(self.carusel, id: \.id) { item in
                                      SubscribeCaruselView(subscribeData: item)
                                            .frame(width: geometry.size.width)
                                   }
                            }
                        }.frame(width: geometry.size.width, height: geometry.size.height / 2)
                  
                
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text("Subscribe")
                    }
                    .padding()
                    .frame(width: geometry.size.width - 40, height: 40)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(5)
                }.padding(.bottom, 10)
                
                

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Maybe Later")
                        .foregroundColor(Color.black)
                        .padding(.bottom, 30)
                }

                Spacer()
          

                Text("Terms & Subscription")
                    .foregroundColor(Color.white)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
                    .font(.system(size: 8))
                    .multilineTextAlignment(.center)
                Text("Terms & Privacy")
                    .foregroundColor(Color.white)
                    .padding(.bottom, 35)
                    .font(.system(size: 12))
                
            }
            .onAppear() {
                self.onAppear()
               
            }
           
        }
        .background(ui.lightPrimaryColor)
        .edgesIgnoringSafeArea(.all)
        
        }
       

}


struct SubscribeCaruselView: View {
    var subscribeData: SubscribeModel
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                Image("\(self.subscribeData.image)")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .aspectRatio(contentMode: ContentMode.fill)
                    .clipShape(Circle())
                    .padding(20)
                   
              
               
                Text("\(self.subscribeData.titleText)")
                    .frame(width: geometry.size.width, height: 20, alignment: .center)
                    .font(.title)
                    .padding(.bottom, 15)
                    .padding(.top, 15)
                    .foregroundColor(Color.white)
                
//                Text("\(self.subscribeData.descriptionText)")
//                    .lineLimit(nil)
//                    .padding(.leading, 15)
//                    .padding(.trailing, 15)
//                    .font(.system(size: 14))
//                    .frame(width: geometry.size.width, height: 60, alignment: .center)
//                    .multilineTextAlignment(.center)

                
                Spacer()
            }
            .background(ui.lightPrimaryColor)
           
        }
    }
}
