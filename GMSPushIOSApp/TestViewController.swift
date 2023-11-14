


import UIKit
import PushSDK

class TestViewController : UIViewController{
    
    
    @IBOutlet var textView : UITextView!
    @IBOutlet var getDevicesBtn : UIButton!
    @IBOutlet var updateBtn : UIButton!
    @IBOutlet var clearDevicesBtn : UIButton!
    
    var pushSDK : PushSDK!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemCyan
        textView.backgroundColor = .systemCyan
    }
    
    //test api of getting all devices
    @IBAction func getAllDeviices(){
        
        textView.text = pushSDK.pushGetDeviceAllFromServer().toString()
    }
    
    //test api of registration updating
    @IBAction func updateRegistration(){
        
        textView.text = pushSDK.pushUpdateRegistration().toString()
        
    }
    
    //clear all devices
    @IBAction func clearDevices(){
        
        let answer = pushSDK.pushClearAllDevice()
        print("answer")
        print(answer)
        textView.text = answer.toString()
        
    }
    
    //clear this devic
    @IBAction func clearCurrentDevice(){
        
        let answer = pushSDK.pushClearCurrentDevice()
        print("answer")
        print(answer)
        textView.text = answer.toString()
        
    }
    
    func showAlert(title:String, message:String){
        let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
            
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion:nil)
    }
    
    
    
}
