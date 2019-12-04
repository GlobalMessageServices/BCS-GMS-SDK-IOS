//
//  ViewController.swift
//  PushDemo
//

import UIKit
import HyberSDK



class ViewController: UIViewController {
    
    
    //let dfd = Initialization.init()
    
    let name = Notification.Name("didReceiveData")

    override func viewDidLoad() {
        super.viewDidLoad()
        txt1fiIn.text=Constants.hyber_user_msisdn
        self.hideKeyboard()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveData, object: nil)
        
        let sk_adapter = HyberSDK.init(user_msisdn: "375291234567", user_password: "Password")
        Constants.hyber_user_msisdn=txt1fiIn.text ?? "375291234567"
        sk_adapter.hyber_check_queue()
    }
    
    @objc func onDidReceiveData(_ notification:Notification) {
        // Do something now
        print("ncenter shshdfghf")
        print(notification.userInfo)
        let jsonData = try? JSONSerialization.data(withJSONObject: notification.userInfo, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        let newString = String(jsonString).replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        //textOutput.text = newString
        print(newString)
        
        textOutput.text = textOutput.text + "\n" + newString
    }
    
    @IBOutlet weak var textOutput: UITextView!
    
    @IBOutlet weak var txt1fiIn: UITextField!
    
    
    @IBAction func onClick(_ sender: UIButton, forEvent event: UIEvent){
        
        // Get current label text.
    }

    @IBAction func button1Click(_ sender: UIButton) {
        let sk_adapter = HyberSDK.init(user_msisdn: "375291234567", user_password: "Password")
        Constants.hyber_user_msisdn=txt1fiIn.text ?? "375291234567"
        textOutput.text = ""//txt1fiIn.text
        

        
        

        
        
    }
    
    @IBAction func button2register(_ sender: UIButton) {
        let sk_adapter = HyberSDK.init(user_msisdn: "375291234567", user_password: "Password")
        Constants.hyber_user_msisdn=txt1fiIn.text ?? "375291234567"
        //print(txt1fiIn.text)
        //print(Constants.firebase_registration_token!)
        textOutput.text = textOutput.text + "\n" + sk_adapter.hyber_register_new(user_phone: txt1fiIn.text ?? "375291234567", user_password: "1", x_hyber_sesion_id: Constants.firebase_registration_token!, x_hyber_ios_bundle_id: "123456789", x_hyber_app_fingerprint: "AIzaSyDvNUnk7R5Qx_aaMCFjFAWTi2jY8vbZW88")
    }
    

    
    @IBAction func button3core(_ sender: UIButton) {
        let sk_adapter = HyberSDK.init(user_msisdn: "375291234567", user_password: "Password")
        //dfd.retrieveData()
        //UserDefaults.standard.set(true, forKey: "Key1") //Bool
        //UserDefaults.standard.set(1, forKey: "Key2")  //Integer
        //UserDefaults.standard.set("TEST", forKey: "Key3") //setObject
        //UserDefaults.standard.synchronize()

        let string = "ggggg"
        //let matched = matches(for: "[0-9]", in: string)
        //print(matched)
    }
    
    @IBAction func button4savecore(_ sender: UIButton) {
        let sk_adapter = HyberSDK.init(user_msisdn: "375291234567", user_password: "Password")
        
        var hhhh = sk_adapter.hyber_check_queue()
        print(hhhh)

        
        
        //dfd.createData(key: "registrationstatus",value: "0")
        //let age = UserDefaults.standard.bool(forKey: "Key1")
        //let aaa = UserDefaults.standard.integer(forKey: "Key2")
        //let pi = UserDefaults.standard.string(forKey: "Key3")
        //print(age)
        //print(aaa)
        //print(pi as! String)
        //let company1 = kSecAttrDescription.insertNewObject(forEntityName: "Company", into: moc)
        //company1.setValue("077456789111", forKey: "inn")
        //company1.setValue("Натура кура", forKey: "name")
    }
    
    @IBAction func button5clearself(_ sender: UIButton) {
        let sk_adapter = HyberSDK.init(user_msisdn: "375291234567", user_password: "Password")
        Constants.hyber_user_msisdn=txt1fiIn.text ?? "375291234567"
        textOutput.text = textOutput.text + "\n" + sk_adapter.hyber_clear_current_device()
    }
    
    @IBAction func button6getdevice(_ sender: UIButton) {
        let sk_adapter = HyberSDK.init(user_msisdn: "375291234567", user_password: "Password")
        Constants.hyber_user_msisdn=txt1fiIn.text ?? "375291234567"
        
        
        textOutput.text = textOutput.text + "\n" + sk_adapter.hyber_get_device_all_from_hyber()
    }
    
    @IBAction func button7callback(_ sender: UIButton) {
        let sk_adapter = HyberSDK.init(user_msisdn: "375291234567", user_password: "Password")
        Constants.hyber_user_msisdn=txt1fiIn.text ?? "375291234567"
        textOutput.text = textOutput.text + "\n" + sk_adapter.hyber_send_message_callback(message_id: "test", message_text: "privet")
    }
    
    
    @IBAction func button8dr(_ sender: UIButton) {
        let sk_adapter = HyberSDK.init(user_msisdn: "375291234567", user_password: "Password")
        Constants.hyber_user_msisdn=txt1fiIn.text ?? "375291234567"
        textOutput.text = textOutput.text + "\n" + sk_adapter.hyber_message_delivery_report(message_id: "1251fqf4")
    }
    
    @IBAction func button9update(_ sender: UIButton) {
        let sk_adapter = HyberSDK.init(user_msisdn: "375291234567", user_password: "Password")
        Constants.hyber_user_msisdn=txt1fiIn.text ?? "375291234567"
        textOutput.text = textOutput.text + "\n" + sk_adapter.hyber_update_registration()
    }
    
    
    
    @IBAction func button10gethistory(_ sender: UIButton) {
        let sk_adapter = HyberSDK.init(user_msisdn: "375291234567", user_password: "Password")
        Constants.hyber_user_msisdn=txt1fiIn.text ?? "375291234567"
        let aaaaa = sk_adapter.hyber_get_message_history(period_in_seconds: 12345)
        textOutput.text = textOutput.text + "\n" + aaaaa
    }
    
    
    @IBAction func button11clearall(_ sender: Any) {
        let sk_adapter = HyberSDK.init(user_msisdn: "375291234567", user_password: "Password")
        let cle_p = sk_adapter.hyber_clear_all_device()
        textOutput.text = textOutput.text + "\n" + cle_p
    }
}

