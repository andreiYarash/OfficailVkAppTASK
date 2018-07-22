import UIKit
import VK_ios_sdk
class VkStatisticsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
 
    
    @IBOutlet weak var userNameAndSurname: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logOut: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    private let vkLogic = PrivateUserVkLogic()
    private var arrayOfWallRecords:[String] = []
    
    private var dataForTableView:[[PrivateUserVkLogic.LogicWallJsonData.ArrayItems]] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfWallRecords.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = arrayOfWallRecords[indexPath.row]
        
        return cell!
    }
    
    @IBAction func logOut(_ sender: Any) {
        
        let vc:UIAlertController = UIAlertController(title: "Log out of VK Account?", message: nil, preferredStyle: .alert)
        let viewActonFirst = UIAlertAction(title: "Log Out", style: .default) { (action) in
             VKSdk.forceLogout()
             // MARK: Set value for UserDefault Key
            UserDefaults.standard.set(false, forKey: SignUpKeysItems.loginKeyUserDefaults.isLoginKey)
            self.performSegue(withIdentifier: "LogOut", sender: self)
          // Switcher.rootViewController()
           
      
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
    
    func prepareUserWallData(){
        vkLogic.requestWallRecoders(tokenKey: VKSdk.accessToken().accessToken) { (data, err) in
            guard let dataIN = data?.response?.items else{return}
            
            for eachRecord in dataIN{
                if (eachRecord?.text?.isEmpty)! != true{
                    guard let text = eachRecord?.text else{return}
                    self.arrayOfWallRecords.append(text)
                   print(text)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                   
                }else{
                    print("No text")
                }
                
                
            }
        }
    }
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUserWallData()
        prepareUserData()
        prepareVkSession()
        
        //Custom Button
        logOut.layer.cornerRadius = 18
        logOut.clipsToBounds = true
        print("Static screen")
        print(dataForTableView)
        
}
}
