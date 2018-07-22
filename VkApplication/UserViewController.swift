import UIKit

class UserViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var userDataSwitcher: UISwitch!
    @IBOutlet weak var wallDataSwitcher: UISwitch!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    // max length  vk_id
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else{
            return true
        }
        let newLength = text.count + string.count - range.length
        return newLength <= 9
    }
    
    @IBAction func GetData(_ sender: Any) {
       
    }
    
    func createSettingsKeyboard(){
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action:#selector(self.doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        self.textField.inputAccessoryView = toolbar
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSettingsKeyboard()
        textField.delegate = self
       let instance = PublicVkLogic()
        instance.requestUserPhotos(tokenKey: "f57c64cff57c64cff57c64cfadf5197b8dff57cf57c64cfae3d78bdb68adb6129a9e1f8") { (data, err) in
            guard let data = data else{return}
            print(data.response.items[0]?.sizes[0]?.url)
        }
        
    }
 
    }

