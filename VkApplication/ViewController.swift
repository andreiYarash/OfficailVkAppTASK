import Foundation
import VK_ios_sdk
class ViewController: UIViewController,VKSdkDelegate,VKSdkUIDelegate{
    
    fileprivate let vk_Token:String = "ca7f26a2dd5fcc439548accfe8cd76ce13a0fcbefc8b5a684850586f10e32b2d843ea5f94413ecbcbd001"
    
    let instanceVK = VKSdk.initialize(withAppId: "6627138")
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        
       self.present(controller!, animated: true, completion: nil)
        
                        //Run Safari
        
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
     
        guard let tokinKeyIn = result.token.accessToken else{return}
        print(tokinKeyIn)
    
    }

    func vkSdkUserAuthorizationFailed() {
        print("error authorized!")
    }
    
    func prepareVkServices(){
        let scopePermissions = ["email", "friends", "wall", "offline", "photos", "notes"]
        
        VKSdk.wakeUpSession(["email","offline","friends"]) { (state, err) in
            if state == VKAuthorizationState.authorized{
                VKSdk.forceLogout()
                print("yes we go")
            }else{
                print("continue working!")
            }
            
            if VKSdk.vkAppMayExists() == true{
                //If we have app
                VKSdk.authorize(scopePermissions, with: .unlimitedToken)
                
            }else{
                //if we  dont have VK App
                VKSdk.authorize(scopePermissions, with:[.disableSafariController,.unlimitedToken])
            }
        }
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareVkServices()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //Delegates
        instanceVK?.register(self)
        instanceVK?.uiDelegate = self
    }
}

