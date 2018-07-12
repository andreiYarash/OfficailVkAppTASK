import UIKit
import SafariServices
import VK_ios_sdk

class SignUpViewController: UIViewController,VKSdkDelegate,VKSdkUIDelegate,SFSafariViewControllerDelegate{
    
    let vkLogic = VkLogic()
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var linkedinButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var vkButton: UIButton!
    
    var resultArray:[VkLogic.LogicGetJsonData.ArrayObject] = []
    private let instanceVK = VKSdk.initialize(withAppId: "6627138")
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
       self.present(controller!, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(captchaError.errorText!)
    }

    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        
        if result.token.userId != nil {
            
            guard let tokenKey = result.token.accessToken else{ return}
            self.vkLogic.requestUserData(tokenKey: tokenKey) { (data, err) in
                print("Result from closure is:\(data?.response)")
                let bla = data?.response
                self.resultArray.append(bla![0]!)
                
                print("array of data!!! :\(self.resultArray)")
            }
            
        }else{
            print("error")
        }
    }
    
  
    func vkSdkDidDismiss(_ controller: UIViewController!) {
       dismiss(animated: true, completion: nil)
    }

    func vkSdkUserAuthorizationFailed() {
        print("error authorized!")
    }
    
    func prepareVkServices(){
        let scopePermissions = ["email", "friends", "wall", "offline", "photos", "notes"]
        
        VKSdk.wakeUpSession(["email","offline","friends"]) { (state, err) in
            
            if VKSdk.vkAppMayExists() == true{
                //If we have app
                VKSdk.authorize(scopePermissions, with: .unlimitedToken)
                
            }else{
                //if we  dont have VK App
                VKSdk.authorize(scopePermissions, with:[.disableSafariController,.unlimitedToken])
            }
            
            if state == VKAuthorizationState.authorized{
                print("yes we go")
               self.performSegue(withIdentifier: "Transfer", sender: self.signInButton)
            }
            
        }
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        self.prepareVkServices()
        
    }
    
    @IBAction func showInstagramPage(_ sender: Any) {
        let linkedinUrlString:String = "https://www.instagram.com/andrew_fun_official/"
        
        if let url = URL(string: linkedinUrlString){
            
            let linkedinVC = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            linkedinVC.delegate = self
            present(linkedinVC, animated: true, completion: nil)
            
        }else{
            print("Error enter linkedin service")
        }
        
    }
    
    @IBAction func showLinkedinPage(_ sender: Any) {
        let linkedinUrlString:String = "https://www.linkedin.com/in/ayarosh/"
      
        if let url = URL(string: linkedinUrlString){
            
            let linkedinVC = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            linkedinVC.delegate = self
            present(linkedinVC, animated: true, completion: nil)
            
        }else{
            print("Error show linkedin Page")
        }
        
    }
    
    
    @IBAction func showVkPage(_ sender: Any) {
        let linkedinUrlString:String = "https://vk.com/it_area"
        
        if let url = URL(string: linkedinUrlString){
            
            let linkedinVC = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            linkedinVC.delegate = self
            present(linkedinVC, animated: true, completion: nil)
            
        }else{
            print("Error show Vk Page")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Delegates
        instanceVK?.register(self)
        instanceVK?.uiDelegate = self
        
        //Custom Button View
        signInButton.layer.cornerRadius = 20
        signInButton.clipsToBounds = true
        linkedinButton.layer.cornerRadius = 20
        linkedinButton.clipsToBounds = true
        vkButton.layer.cornerRadius = 20
        vkButton.clipsToBounds = true
        instagramButton.layer.cornerRadius = 20
        instagramButton.clipsToBounds = true
        
        //Check Authorization
        VKSdk.wakeUpSession(["email","offline","friends"]) { (state, err) in

            if state == VKAuthorizationState.authorized{
                print("yes we go")
                self.performSegue(withIdentifier: "Transfer", sender: self.signInButton)
            }
        }
    }
}
