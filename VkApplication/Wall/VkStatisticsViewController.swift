import UIKit
import VK_ios_sdk
class VkStatisticsViewController: UIViewController {
    
    @IBOutlet weak var userNameAndSurname: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var logOut: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    private let vkLogic = PrivateUserVkLogic()

    @IBAction func logOut(_ sender: Any) {
        
        let vc:UIAlertController = UIAlertController(title: "Log out of VK Account?", message: nil, preferredStyle: .alert)
        let viewActonFirst = UIAlertAction(title: "Log Out", style: .default) { (action) in
             VKSdk.forceLogout()
             // MARK: Set value for UserDefault Key
            UserDefaults.standard.set(false, forKey: SignUpKeysItems.loginKeyUserDefaults.isLoginKey)
            self.performSegue(withIdentifier: "LogOut", sender: self)
        }
        let viewActionSecond = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        vc.addAction(viewActonFirst)
        vc.addAction(viewActionSecond)
        
        present(vc, animated: true, completion: nil)
    }

    func prepareVkSession(){
        VKSdk.wakeUpSession(["email","offline","friends"]) { (state, err) in
            if state == VKAuthorizationState.authorized{
                
                print("We have user permissions")
                
            } else{print("STOP WORKING !!!!!!!")}
        }
    }
    
    func prepareUserData(){
        vkLogic.requestUserData(tokenKey: VKSdk.accessToken().accessToken) { (data, err) in
            guard let userData = data?.response[0] else{
              return
            }
           
            if let firstName = userData.first_name, let lastName = userData.last_name{
                self.userNameAndSurname.text = "\(firstName) \(lastName)"
            } else{
                return
            }
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUserData()
        prepareVkSession()
        //Custom Button
        logOut.layer.cornerRadius = 18
        logOut.clipsToBounds = true
}
}
