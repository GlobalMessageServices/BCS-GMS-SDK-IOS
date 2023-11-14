//
//  AuthViewController.swift
//  GMSPushIOSApp
//
//  Created by o.korniienko on 30.05.22.
//

import UIKit
import Network


class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var mainController : ViewController!
    
    @IBOutlet var table : UITableView!
    @IBOutlet var emptyLabel : UILabel!
    
    var messages : [(date: String, title: String, body: String)] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemCyan
        
        table.backgroundColor = .systemCyan
        
        table.delegate = self
        table.dataSource = self
            
        
        
        
        if(messages.count > 0){
            
            //sort messages by date
            let sortedMessaes = messages.sorted{(initial, next) -> Bool in
                let dateFoormater = DateFormatter()
                dateFoormater.timeZone = TimeZone(abbreviation: "UTC")
                dateFoormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                let dateStr1 = initial.date.split(separator: ".")[0]
                let dateStr2 = next.date.split(separator: ".")[0]
                let mssDate1 = dateFoormater.date(from: String(dateStr1))
                let mssDate2 = dateFoormater.date(from: String(dateStr2))
                
                return mssDate1! > mssDate2!
                
            }
            messages = sortedMessaes
            emptyLabel.isHidden = true
            table.isHidden = false
        }
            
    }
    
    
    
    //Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let textLabel = CustomFormatter.formateDate(input: messages[indexPath.row].date) + "  -  " + messages[indexPath.row].title
        cell.textLabel?.text = textLabel
        cell.detailTextLabel?.text = messages[indexPath.row].body
        cell.backgroundColor = .systemCyan
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let message = messages[indexPath.row]
        
        //show single message
        guard let vc = storyboard?.instantiateViewController(identifier: "mss") as? MessageViewController else{
            return
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Message"
        vc.date = message.date
        vc.messageTitle = message.title
        vc.body = message.body
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    
    

}


