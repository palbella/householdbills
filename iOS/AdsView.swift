import Foundation
import GoogleMobileAds
import SwiftUI
import UIKit

final class RewardedAd {
    private let rewardId = "ca-app-pub-5580922665242762/7113910944" // test: ca-app-pub-3940256099942544/1712485313 prod: ca-app-pub-5580922665242762/7113910944 "ca-app-pub-5580922665242762~9922486233"
    
    var rewardedAd: GADRewardedAd?
    
    init() {
        load()
    }
    
    func load(){
        GADRewardedAd.load(withAdUnitID: rewardId, request: GADRequest(), completionHandler: {rewardedAd, error in
            if error != nil {
                return
            }
            self.rewardedAd = rewardedAd
            
        })
    }
    
    func showAd(rewardFunction: @escaping () -> Void) -> Bool {
        guard let rewardedAd = rewardedAd, let root = UIApplication.shared.keyWindowPresentedController else {
            return false
        }
        
        rewardedAd.present(fromRootViewController: root, userDidEarnRewardHandler: rewardFunction)
        return true
    }
}

extension UIApplication {
    
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    
    var keyWindowPresentedController: UIViewController? {
        var viewController = self.keyWindow?.rootViewController
        
        if let presentedController = viewController as? UITabBarController {
            viewController = presentedController.selectedViewController
        }
        
        while let presentedController = viewController?.presentedViewController {
            if let presentedController = presentedController as? UITabBarController {
                viewController = presentedController.selectedViewController
            } else {
                viewController = presentedController
            }
        }
        return viewController
    }
}


final private class BannerVC: UIViewControllerRepresentable  {

    private let bannerId = "ca-app-pub-5580922665242762/8041664011" // test: ca-app-pub-3940256099942544/2934735716 prod: ca-app-pub-5580922665242762/8041664011 "ca-app-pub-5580922665242762~9922486233"
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        let adSize = GADAdSizeFromCGSize(CGSize(width: 320, height: 100))
        let view = GADBannerView(adSize: adSize)

        let viewController = UIViewController()
        view.adUnitID = bannerId
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: adSize.size)
        view.load(GADRequest())

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct BannerAd:View{
    var body: some View{
        HStack{
            Spacer()
            BannerVC().frame(width: 320, height: 50, alignment: .center)
            Spacer()
        }
    }
}

//struct Banner_Previews: PreviewProvider {
//    static var previews: some View {
//        Banner()
//    }
//}
