import UIKit

struct SignUpKeysItems{
    struct StoryboardID{
        static let tabBarController = "TabBarController"
        static let signUpController = "SignUpViewController"
    }
    struct loginKeyUserDefaults{
        static let isLoginKey = "isLogin"
    }
}
class Switcher{
    static func rootViewController()->Void{
        
        let statusAuthorization:Bool = UserDefaults.standard.bool(forKey: SignUpKeysItems.loginKeyUserDefaults.isLoginKey)
        var rootViewController:UIViewController?
        
        if (statusAuthorization == true){
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: SignUpKeysItems.StoryboardID.tabBarController)
            rootViewController = vc
            
        }else{
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: SignUpKeysItems.StoryboardID.signUpController)
            rootViewController = vc
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootViewController
        appDelegate.window?.makeKey()
    }
}
