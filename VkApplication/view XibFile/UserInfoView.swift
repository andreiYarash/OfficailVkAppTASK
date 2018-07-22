import UIKit

@IBDesignable

class UserInfoView: UIView {

    @IBOutlet weak var view:UIView!
    
    
    private func configureXIB(){
        view = configureNib()
        Bundle.main.loadNibNamed("UserInfoView", owner: self, options: nil)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        addSubview(view)
    }
    func configureNib()->UIView{
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "UserInfoView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
  
    override init(frame: CGRect) {
        super.init(frame: frame)
       configureXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        configureXIB()
    }
    
    
}
