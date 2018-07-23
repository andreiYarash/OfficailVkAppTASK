import UIKit

class VKTabBarController: UITabBarController {
    
    private let tabBarItemImages = [
            "UserWall",
            "Search",
            "Settings"
    ]
    private let tabBarItemImagesSelected = [
            "SelectedUserWall",
            "SelectedSearch",
            "SelectedSettings"
    ]
    private let tabBarItemTitles = [
            "Wall",
            "Search",
            "Account"
    ]
    func customizingTabBarItems(){
        guard let customTabBar = tabBar.items else{return}
        
        for number in 0..<customTabBar.count {
            let offSet:CGFloat = 5
            let tabBar = customTabBar[number]
            let image = tabBarItemImages[number]
            let tabBarImage = UIImage(named: image)
            let selectedImage = tabBarItemImagesSelected[number]
            let selectedTabBarImage = UIImage(named: selectedImage)
            let tabBarImageInsets = UIEdgeInsetsMake(offSet, 0, -offSet, 0)
            
            tabBar.image = tabBarImage
            tabBar.selectedImage = selectedTabBarImage
            tabBar.imageInsets = tabBarImageInsets
            tabBar.title = nil
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizingTabBarItems()
        
    }
}
