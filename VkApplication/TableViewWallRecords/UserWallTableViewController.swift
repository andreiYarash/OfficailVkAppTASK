import UIKit
import VK_ios_sdk
class UserWallTableViewController: UITableViewController {
    
    private let vkLogic = PrivateUserVkLogic()
    private var arrayOfWallRecords:[String] = []
    
    
    @objc private func refreshWallRecords(_ sender:Any){
        DispatchQueue.main.async {
            self.arrayOfWallRecords = []
            self.prepareUserWallData()
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            
        }
        
    }
    
    func prepareUserWallData(){
        VKSdk.wakeUpSession(["email","offline","friends"]) { (state, err) in
            
            self.vkLogic.requestWallRecoders(tokenKey:VKSdk.accessToken().accessToken) { (data, err) in
                guard let dataRecords = data?.response?.items else{return}
                
                for eachRecord in dataRecords{
                    if (eachRecord?.text?.isEmpty)! != true{
                        guard let text = eachRecord?.text else{return}
                        self.arrayOfWallRecords.append(text)
                        print("Add record:\(text)")
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    else{
                        print("Error in records parse)")
                    }
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUserWallData()
        refreshControl?.tintColor = UIColor(red: 0.25, green: 0.72, blue: 85, alpha: 1)
        refreshControl?.addTarget(self, action: #selector(refreshWallRecords(_:)), for: .valueChanged)
        refreshControl?.attributedTitle = NSAttributedString(string: "Fetching Wall Records...", attributes: [NSAttributedStringKey.foregroundColor:UIColor(red: 0.04, green: 0.45, blue: 0.85, alpha: 1)])
        
    }
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfWallRecords.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WallRecord", for: indexPath)
        
        let recordWall = self.arrayOfWallRecords[indexPath.row]
        cell.textLabel?.text = recordWall
        print("TEXT IS:\(recordWall )")
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
