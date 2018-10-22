import UIKit
import SafariServices
import VK_ios_sdk

class SignUpViewController: UIViewController,VKSdkDelegate,VKSdkUIDelegate,SFSafariViewControllerDelegate{
    
    let vkLogic = PrivateUserVkLogic()
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var linkedinButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var vkButton: UIButton!
    
    var resultArray:[PrivateUserVkLogic.LogicGetJsonData.ArrayObject] = []
    private let instanceVK = VKSdk.initialize(withAppId: "YOUR_APP_ID")
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.present(controller!, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        
        if (captchaError != nil){
            if (captchaError.errorCode == VK_API_CANCELED)  {
                UserDefaults.standard.set(false, forKey: SignUpKeysItems.loginKeyUserDefaults.isLoginKey)
                Switcher.rootViewController()
            }
        }
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        //MARK: Check Result status of Outh
        
        switch result.state {
        case .error:
            UserDefaults.standard.set(false, forKey: SignUpKeysItems.loginKeyUserDefaults.isLoginKey)
        case .initialized:
            UserDefaults.standard.set(false, forKey: SignUpKeysItems.loginKeyUserDefaults.isLoginKey)
        case .authorized:
            UserDefaults.standard.set(false, forKey: SignUpKeysItems.loginKeyUserDefaults.isLoginKey)
        case .pending:
            UserDefaults.standard.set(true, forKey: SignUpKeysItems.loginKeyUserDefaults.isLoginKey)
            Switcher.rootViewController()
        default:
            break
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("Error Authorized!")
    }
    
    func prepareVkServices(){
        
        let scopePermissions = ["email", "friends", "wall", "offline", "photos", "notes"]
        VKSdk.wakeUpSession(["email","offline","friends"]) { (state, err) in
            
            if state == VKAuthorizationState.authorized {
                print("yes we go")
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
    }
}
