//
//  VkStatisticsViewController.swift
//  VkApplication
//
//  Created by Andrei Yarash on 7/10/18.
//  Copyright © 2018 Andrei Yarash. All rights reserved.
//

import UIKit
import VK_ios_sdk
class VkStatisticsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
 
    
    @IBOutlet weak var userNameAndSurname: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logOut: UIButton!
    
    private let vkLogic = VkLogic()
    var ssd:[String] = []
    
    private var dataForTableView:[[VkLogic.LogicWallJsonData.ArrayItems]] = []
    
    @IBAction func logOut(_ sender: Any) {
        let vc:UIAlertController = UIAlertController(title: "LogOut", message: "Do you want Log Out", preferredStyle: .actionSheet)
        let viewActonFirst = UIAlertAction(title: "Log Out", style: .default) { (action) in
             VKSdk.forceLogout()
        }
        let viewActionSecond = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        vc.addAction(viewActonFirst)
        vc.addAction(viewActionSecond)
        
        present(vc, animated: true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ssd.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
       cell?.textLabel?.text = self.ssd[indexPath.row]
        
        return cell!
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
            let userData = data?.response[0]
            self.userNameAndSurname.text = "\(userData!.first_name!) \(userData!.last_name!)"
            
        }
    }
    
    func prepareUserWallData(){
     
        vkLogic.requestWallRecoders(tokenKey: VKSdk.accessToken().accessToken) { (data, err) in
            guard let dataIN = data?.response?.items else{return}
            for eachRecord in dataIN{
                self.ssd.append((eachRecord?.text)!)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            print(eachRecord?.text)
                
            }
        }
    }
  
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUserWallData()
        prepareVkSession()
        prepareUserData()
        //Custom Button
        logOut.layer.cornerRadius = 18
        logOut.clipsToBounds = true
        print("Static screen")
        print(dataForTableView)
    }
}
