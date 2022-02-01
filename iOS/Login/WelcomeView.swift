//
//  WelcomeView.swift
//  HouseholdBills (iOS)
//
//  Created by Pablo Albella on 10/10/21.
//

import UIKit
import SwiftUI

struct OnboardingModel {
    var id: Int
    var image: String
    var titleText: String
    var descriptionText: String
    var showButton: Bool?
}

struct WelcomeView: View {
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.colorScheme) var colorScheme
    
    var onboardingDataArray: [OnboardingModel] = [
        OnboardingModel(id: 1, image: "welcome1", titleText: LocalizedStringKey("WelcomeTitle1").toString(), descriptionText: LocalizedStringKey("WelcomeDescription1").toString()),
        OnboardingModel(id: 2, image: "welcome2", titleText: LocalizedStringKey("WelcomeTitle2").toString(), descriptionText: LocalizedStringKey("WelcomeDescription2").toString()),
        OnboardingModel(id: 3, image: "welcome3", titleText: LocalizedStringKey("WelcomeTitle3").toString(), descriptionText: LocalizedStringKey("WelcomeDescription3").toString()),
        OnboardingModel(id: 4, image: "welcome4", titleText: LocalizedStringKey("WelcomeTitle4").toString(), descriptionText: LocalizedStringKey("WelcomeDescription4").toString()),
        OnboardingModel(id: 5, image: "welcome5", titleText: LocalizedStringKey("WelcomeTitle5").toString(), descriptionText: LocalizedStringKey("WelcomeDescription5").toString(), showButton: true)
    ]
    
    var body: some View {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            NavigationView {
        GeometryReader { geometry in
       
                    ZStack {
                        NavigationLink(destination: LogInView(), isActive: self.$settings.navigateNowToLogIn) { EmptyView() }
                        NavigationLink(destination: SignUpView(), isActive: self.$settings.navigateNowToSignup) { EmptyView() }
                        
                        WelcomeScrollView(axis: .horizontal, numberOfPages: self.onboardingDataArray.count, pagingEnabled: true, pageControlEnabled: true, hideScrollIndicators: true, currentPageIndicator: .black, pageIndicatorTintColor: .gray) {
                                    HStack(spacing: 0) {
                                        ForEach(self.onboardingDataArray, id: \.id) { item in
                                              OnboardingView(onboardingData: item)
                                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                           }
                                    }
                                }.frame(width: geometry.size.width, height: geometry.size.height)
                    }
                 
                    
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
            
            
            
        } else {
        NavigationView {
    GeometryReader { geometry in
   
                ZStack {
                    NavigationLink(destination: LogInView(), isActive: self.$settings.navigateNowToLogIn) { EmptyView() }
                    NavigationLink(destination: SignUpView(), isActive: self.$settings.navigateNowToSignup) { EmptyView() }
                    
                    WelcomeScrollView(axis: .horizontal, numberOfPages: self.onboardingDataArray.count, pagingEnabled: true, pageControlEnabled: true, hideScrollIndicators: true, currentPageIndicator: .black, pageIndicatorTintColor: .gray) {
                                HStack(spacing: 0) {
                                    ForEach(self.onboardingDataArray, id: \.id) { item in
                                          OnboardingView(onboardingData: item)
                                                .frame(width: geometry.size.width, height: geometry.size.height)
                                       }
                                }
                            }.frame(width: geometry.size.width, height: geometry.size.height)
                }
             
                
            }
        }
        .accentColor(colorScheme != .dark ? ui.lightPrimaryColor: ui.darkPrimaryColor)
    }
    }
}

enum DirectionX {
    case horizontal
    case vertical
}

struct WelcomeScrollView<Content: View>: UIViewControllerRepresentable {
    var content: () -> Content
    var axis: DirectionX
    var numberOfPages = 0
    var pagingEnabled: Bool = false
    var pageControlEnabled: Bool = false
    var hideScrollIndicators: Bool = false
    var currentPageIndicator: UIColor?
    var pageIndicatorTintColor: UIColor?
  

    init(axis: DirectionX, numberOfPages: Int,
         pagingEnabled: Bool,
         pageControlEnabled: Bool,
         hideScrollIndicators: Bool,
         currentPageIndicator: UIColor? = .white,
         pageIndicatorTintColor: UIColor? = .gray,
         @ViewBuilder content: @escaping () -> Content) {

        self.content = content
        self.numberOfPages = numberOfPages
        self.pagingEnabled = pagingEnabled
        self.pageControlEnabled = pageControlEnabled
        self.hideScrollIndicators = hideScrollIndicators
        self.currentPageIndicator = currentPageIndicator
        self.pageIndicatorTintColor = pageIndicatorTintColor
     
        self.axis = axis
    }

    func makeUIViewController(context: Context) -> WelcomeUIScrollViewController<Content> {
        let vc = WelcomeUIScrollViewController(rootView: self.content())
        vc.axis = axis
        vc.numberOfPages = numberOfPages
        vc.pagingEnabled = pagingEnabled
        vc.pageControlEnabled = pageControlEnabled
        vc.hideScrollIndicators = hideScrollIndicators
        vc.currentPageIndicator = currentPageIndicator
        vc.pageIndicatorTintColor = pageIndicatorTintColor
     
        return vc
    }

    func updateUIViewController(_ viewController: WelcomeUIScrollViewController<Content>, context: Context) {
        viewController.hostingController.rootView = self.content()
    }
}


class WelcomeUIScrollViewController<Content: View>: UIViewController, UIScrollViewDelegate {

    var axis: DirectionX = .horizontal
    var numberOfPages: Int = 0
    var pagingEnabled: Bool = false
    var pageControlEnabled: Bool = false
    var hideScrollIndicators: Bool = false
    var currentPageIndicator: UIColor?
    var pageIndicatorTintColor: UIColor?

    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.isPagingEnabled = pagingEnabled
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = true
        view.alwaysBounceVertical = false
        return view
    }()

    lazy var pageControl : UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.white
        pageControl.pageIndicatorTintColor = pageIndicatorTintColor ?? .gray
        pageControl.currentPageIndicatorTintColor = currentPageIndicator ?? .white
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.isHidden = !pageControlEnabled
        return pageControl
    }()

    init(rootView: Content) {
        self.hostingController = UIHostingController<Content>(rootView: rootView)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var hostingController: UIHostingController<Content>! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        self.makefullScreen(of: self.scrollView, to: self.view)

        self.hostingController.willMove(toParent: self)
        self.scrollView.addSubview(self.hostingController.view)
        self.makefullScreen(of: self.hostingController.view, to: self.scrollView)
        self.hostingController.didMove(toParent: self)

        view.addSubview(pageControl)
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 60).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
       
    }

    func makefullScreen(of viewA: UIView, to viewB: UIView) {
        viewA.translatesAutoresizingMaskIntoConstraints = false
        viewB.addConstraints([
            viewA.leadingAnchor.constraint(equalTo: viewB.leadingAnchor),
            viewA.trailingAnchor.constraint(equalTo: viewB.trailingAnchor),
            viewA.topAnchor.constraint(equalTo: viewB.topAnchor),
            viewA.bottomAnchor.constraint(equalTo: viewB.bottomAnchor),
        ])
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let currentIndexHorizontal = round(scrollView.contentOffset.x / self.view.frame.size.width)
        let currentIndexVertical = round(scrollView.contentOffset.y / self.view.frame.size.height)

        switch axis {
            case .horizontal:
                self.pageControl.currentPage = Int(currentIndexHorizontal)
            self.pageControl.isHidden = !self.pageControlEnabled || ( Int(currentIndexHorizontal) == self.numberOfPages - 1 )
        
                break
            case .vertical:
                self.pageControl.currentPage = Int(currentIndexVertical)
                break
        }

    }

}


struct OnboardingView: View {
    var onboardingData: OnboardingModel
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var ui: AppUI
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 10) {
                Spacer()
                Image("\(self.onboardingData.image)")
                    .resizable()
                    .frame(width: 300, height: 250)
                    .aspectRatio(contentMode: ContentMode.fill)
                    .clipShape(Circle())
                    .padding(20)
                
                Text("\(self.onboardingData.titleText)")
                    .frame(width: geometry.size.width, height: 20, alignment: .center)
                    .font(.title)
                
                Text("\(self.onboardingData.descriptionText)")
                    .lineLimit(nil)
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
                    .font(.system(size: 16))
                    .frame(width: geometry.size.width, height: 60, alignment: .center)
                    .multilineTextAlignment(.center)
                
//                Spacer(minLength: 20)
                Spacer()
                if self.onboardingData.showButton ?? false {
                    VStack {
                        Button(action: {
                           self.settings.navigateNowToLogIn = true
                        }) {
                               HStack {
                                   Text("Log In")
                               }.frame(width: geometry.size.width - 200, height: 40)
                               .foregroundColor(Color(.white))
                               .background(ui.lightPrimaryColor)
                               .cornerRadius(10)
                               .padding(.bottom, 5)
                           }
                        
                        Button(action: {
                                self.settings.navigateNowToSignup = true
                                }) {
                                HStack {
                                       Text("Sign Up")
                                }.frame(width: geometry.size.width - 200, height: 40)
                                  .foregroundColor(Color(.white))
                                  .background(ui.lightPrimaryColor)
                                  .cornerRadius(10)
                           }
                        
                    }.padding(.bottom, 0)
                }
                
                Spacer()
            }
        }
    }
}
