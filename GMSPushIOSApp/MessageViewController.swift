

import UIKit

class MessageViewController : UIViewController{
    
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var dateLabel : UILabel!
    @IBOutlet var bodyField : UITextView!
    
    var date : String = ""
    var messageTitle : String = ""
    var body : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        titleLabel.text = messageTitle
        dateLabel.text = CustomFormatter.formateDate(input: date)
        bodyField.text = body
        bodyField.backgroundColor = .systemCyan
        
    }
    
    
}
