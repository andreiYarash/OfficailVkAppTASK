import Foundation
import VK_ios_sdk
class ViewController: UIViewController,VKSdkDelegate,VKSdkUIDelegate{
    fileprivate let vk_Token:String = "ca7f26a2dd5fcc439548accfe8cd76ce13a0fcbefc8b5a684850586f10e32b2d843ea5f94413ecbcbd001"
    
    let instanceVK = VKSdk.initialize(withAppId: "6627138")
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        
       self.present(controller!, animated: true, completion: nil)
        
        //Run safari!!!
//                if (self.presentedViewController != nil){
//                    self.dismiss(animated: true) {
//                        self.present(controller!, animated: true, completion: {
//                            print("run Safari")
//                        })
//                    }
//                }else{
//                    self.present(controller, animated: true) {
//                        print("open safari!")
//                    }
//                }
//
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(captchaError.errorText!)
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
     
        guard (result.token.accessToken) != nil else{
            print("ddfdf")
            return
        }
     print(result.token.accessToken!)
    
    }

    
    func vkSdkUserAuthorizationFailed() {
        print("erroro authorized!")
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let scopePermissions = ["email", "friends", "wall", "offline", "photos", "notes"]
        VKSdk.wakeUpSession(["email","offline","friends"]) { (state, err) in
            if state == VKAuthorizationState.authorized{
                VKSdk.forceLogout()
                print("yes go")
            }else{
                print("No,error:")
            }
            
            if VKSdk.vkAppMayExists() == true{
                VKSdk.authorize(scopePermissions, with: .unlimitedToken)
                
            }else{
                VKSdk.authorize(scopePermissions, with:[.disableSafariController,.unlimitedToken])
            }
        }
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        instanceVK?.register(self)
        instanceVK?.uiDelegate = self
        
      
        
 
      
    }
}

