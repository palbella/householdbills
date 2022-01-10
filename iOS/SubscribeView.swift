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
  
    @State var showTerms = false
    
    var carusel: [SubscribeModel] = [
        SubscribeModel(id: 1, image: "subscribe1", titleText: LocalizedStringKey("subscribe1").toString(), descriptionText: LocalizedStringKey("").toString()),
        SubscribeModel(id: 2, image: "subscribe2", titleText: LocalizedStringKey("subscribe2").toString(), descriptionText: LocalizedStringKey("").toString()),
        SubscribeModel(id: 3, image: "subscribe3", titleText: LocalizedStringKey("subscribe3").toString(), descriptionText: LocalizedStringKey("").toString()),
        SubscribeModel(id: 4, image: "subscribe4", titleText: LocalizedStringKey("subscribe4").toString(), descriptionText: LocalizedStringKey("").toString()),
        SubscribeModel(id: 5, image: "subscribe5", titleText: LocalizedStringKey("subscribe5").toString(), descriptionText: LocalizedStringKey("").toString(), showButton: true)
    ]
    
    func onAppear() {
   
    }
    
    var body: some View {
        
        if(!showTerms) {
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
                    IPAService.shared.purchase(product: .year)
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
          

                Text("subscribe-policy")
                    .foregroundColor(Color.white)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
                    .font(.system(size: 8))
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    self.showTerms = true
                }) {
                    Text("Terms & Privacy")
                        .foregroundColor(Color.white)
                        .padding(.bottom, 35)
                        .font(.system(size: 12))
                }
              
                
            }
            .onAppear() {
                self.onAppear()
               
            }
        }
        .background(ui.lightPrimaryColor)
        .edgesIgnoringSafeArea(.all)
            } else {
                TermsView(back: self.$showTerms)
            }
           
        
       
        
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
                   
              
               
//                Text("\(self.subscribeData.titleText)")
//                    .lineLimit(nil)
//                    .frame(width: geometry.size.width, height: 60, alignment: .center)
//                    .font(.title)
//                    .padding(.bottom, 15)
//                    .padding(.top, 15)
//                    .foregroundColor(Color.white)
//                    .multilineTextAlignment(.center)
                    
                
                Text("\(self.subscribeData.titleText)")
                    .lineLimit(nil)
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
                    .font(Font.headline.weight(.bold))
                    .foregroundColor(Color.white)
                    .frame(width: geometry.size.width, height: 60, alignment: .center)
                    .multilineTextAlignment(.center)

                
                Spacer()
            }
            .background(ui.lightPrimaryColor)
           
        }
    }
}
