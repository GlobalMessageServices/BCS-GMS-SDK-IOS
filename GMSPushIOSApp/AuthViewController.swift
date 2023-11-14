

import UIKit
import PushSDK
import TKFormTextField

class AuthViewController: UIViewController {
    
    var mainController : ViewController!
    var pushSDK : PushSDK!
    
    @IBOutlet var registerButton : UIButton!
    @IBOutlet weak var numberTextField : TKFormTextField!
    
    private let PHONE_REGEX = "^([0-9]){10,13}$"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        view.backgroundColor = .systemCyan
        
        
        self.numberTextField.enablesReturnKeyAutomatically = true
        self.numberTextField.returnKeyType = .next
        self.numberTextField.clearButtonMode = .whileEditing
        self.numberTextField.placeholderFont = UIFont.systemFont(ofSize: 18)
        self.numberTextField.font = UIFont.systemFont(ofSize: 27)

        self.numberTextField.lineColor = UIColor.gray
        self.numberTextField.selectedLineColor = UIColor.black

        //floating placeholder title
        self.numberTextField.titleLabel.font = UIFont.systemFont(ofSize: 18)
        self.numberTextField.titleColor = UIColor.lightGray
        self.numberTextField.selectedTitleColor = UIColor.gray

        //error label
        self.numberTextField.errorLabel.font = UIFont.systemFont(ofSize: 18)
        self.numberTextField.errorColor = UIColor.red

        //update error message
        self.numberTextField.addTarget(self, action: #selector(updateError), for: .allEvents)
        
            
    }
    
  
    @objc func updateError(textField : TKFormTextField){
        guard let text = textField.text, !text.isEmpty else{

            return
        }
        let phoneCeck = NSPredicate(format: "SELF MATCHES[c] %@", PHONE_REGEX)
        let isValidNumber = phoneCeck.evaluate(with: text)
        if(!isValidNumber){
            textField.error = "only numbers are allowed, lengt = 10-13"

        }else{
            textField.error = nil
        }
    }
    
    
    
    @IBAction func registerNumber(){
        
        let number = numberTextField.text!
        let phoneCeck = NSPredicate(format: "SELF MATCHES[c] %@", PHONE_REGEX)
        let isValidNumber = phoneCeck.evaluate(with: number)
        
        if(isValidNumber){
            if(mainController.isDeviceregistered()){
                pushSDK.pushClearCurrentDevice()
            }
            let isNumberRegistered = makeRegistration(number: number)
            //let isNumberRegistered = true
            if(isNumberRegistered.code == 200){
                navigationController?.setViewControllers([mainController], animated: true)
            }else{
                numberTextField.error = "code - \(isNumberRegistered.code)" + ", result - " + isNumberRegistered.result + ", description - " + isNumberRegistered.description
            }
                
        
        }
            
        
    }
    
    private func makeRegistration(number:String)->PushKFunAnswerRegister{
        
        let registrator: PushKFunAnswerRegister = pushSDK.pushRegisterNew(user_phone: number, user_password: "1", x_push_sesion_id: PushKConstants.firebase_registration_token ?? "", x_push_ios_bundle_id: "app-bundle-id", X_Push_Client_API_Key: "client-api-key")
        
        if(registrator.code == 200){
           let updateRegistrationAnswer = pushSDK.pushUpdateRegistration()
        }
        
        return registrator
            
        
    }
    
    func showAlert(title:String, message:String){
        let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
            
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion:nil)
    }

}

