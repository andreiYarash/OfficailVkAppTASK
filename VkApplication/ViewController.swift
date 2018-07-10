import UIKit
import VK_ios_sdk

class ViewController: UIViewController,VKSdkDelegate,VKSdkUIDelegate{
    
    @IBAction func exitVkAccount(_ sender: Any) {
        VKSdk.forceLogout()
    }
    
    @IBOutlet weak var userName: UILabel!
    
    private let instanceVK = VKSdk.initialize(withAppId: "6627138")
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        
       self.present(controller!, animated: true, completion: nil)
        
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(captchaError.errorText!)
    }

    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        let vkLogic = VkLogic()
        
        if result.token.userId != nil {
            DispatchQueue.main.async {
                
            
            guard let tokenKey = result.token.accessToken else{return}
            vkLogic.requestUserData(tokenKey:tokenKey)
            vkLogic.requestWallRecoders(tokenKey: tokenKey)
            }
        }
        
        
       print("Instances:\(vkLogic.wallData)")
    
    }

    func vkSdkUserAuthorizationFailed() {
        print("error authorized!")
    }
    
    func prepareVkServices(){
        let scopePermissions = ["email", "friends", "wall", "offline", "photos", "notes"]
        
        VKSdk.wakeUpSession(["email","offline","friends"]) { (state, err) in
            if state == VKAuthorizationState.authorized{
                //VKSdk.forceLogout() // removes cookies vk.com
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
    @IBAction func signIn(_ sender: UIButton) {
        self.prepareVkServices()
        if VKSdk.isLoggedIn(){
           return
        }else{
            self.prepareVkServices()
        }
        
    }
    
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Delegates
        instanceVK?.register(self)
        instanceVK?.uiDelegate = self
       // prepareVkServices()
    }
}
