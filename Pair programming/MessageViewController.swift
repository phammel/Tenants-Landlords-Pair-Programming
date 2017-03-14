//
//  MessageViewController.swift
//  Pair programming
//
//  Created by Phammel on 3/9/17.
//  Copyright © 2017 Phammel. All rights reserved.
//

import UIKit
import Firebase
import SafariServices

class MessageViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate
{
    @IBOutlet weak var messageTableView: UITableView!

    @IBOutlet weak var payBarButton: UIBarButtonItem!
    
    @IBOutlet weak var writeBarButton: UIBarButtonItem!
    
    var houseInfoDic = [String: Any]()
    
    var uuidFromOther = ""
    
    var messages = [String: [String: Any]]()
    
    var TimTimer = Timer()
    
    var localCount = 0
    
    
   //----------- view did load--------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        
        
        ref.child("\(uuidFromOther)/messages").observeSingleEvent(of: .value, with:
            { (snap) in
                if let value = snap.value as? [String: [String: Any]]
                {
                    
                    let names = [String](value.keys)
                    
                    for name in names
                    {
                    
                        let dict = value[name]!
                        self.messages[name] = dict
                    }
                    self.messageTableView.reloadData()
                }
                else
                {
                        self.addmessage(comeInSting: "Welcome", Sender: "System")
                }
        })
        
        
        
        localCount = messages.count
        
        TimTimer = Timer.scheduledTimer(timeInterval: 12, target: self, selector: #selector(timeUpdate), userInfo: nil, repeats: true)
        
        
        
        
        

        // Do any additional setup after loading the view.
    }
    //-------------------------------------------------
    
    
    func addmessage(comeInSting: String, Sender: String)
    {
      //  let thime = NSDate().timeIntervalSince1970
        
        let thime: Int = Int(NSDate().timeIntervalSince1970)
        let data = ["text": comeInSting, "sender": Sender]
        
        
       // set(data, forKey: "\(uuidFromOther)/messages/\(thime)")
        
        
        //if crashes ref.ref
        ref.child("\(uuidFromOther)/messages").updateChildValues(["\(thime)":data])
        
        //ref.updateChildValues([key:val])
        
        
        /*
         func set(_ val: Any, forKey key: String)
         {
         ref.updateChildValues([key:val])
         }
 
         */
    }
    
    
    
    
    
    
    
    
    
    func timeUpdate()
    {
        
        
        
        
        ref.child("\(uuidFromOther)/messages").observe(.value, with:
            { (snap) in
                
                
                
                if let value = snap.value as? [String: [String: Any]]
                {
                    
                    self.messages.removeAll()
                    
                    let names = [String](value.keys)
                    
                    
                    for name in names
                    {
                        
                        let dict = value[name]!
                        self.messages[name] = dict
                    }
                   
                    
                    self.messageTableView.reloadData()
                }
             
        })
        
        self.messageTableView.reloadData()
        
        print("local count")
        print(localCount)
        print("messages.count")
        print(messages.count)
        
        if localCount != messages.count
        {
            
            let notification = UILocalNotification()
            notification.alertBody = "New Message about your Property"
            notification.alertAction = "open"
            notification.fireDate = Date()
            notification.soundName = UILocalNotificationDefaultSoundName
           // notification.userInfo = ["title": item.title, "UUID": item.UUID]
            UIApplication.shared.scheduleLocalNotification(notification)
            
            
            
            localCount = messages.count
            
        }
        
        
        
        
        
        
        
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //----------- pay tap--------------------------------------
    @IBAction func payBarButtonTap(_ sender: Any)
    {
        let myurl = URL(string: "https://www.paypal.com/us/webapps/mpp/send-money-online")
        let SVC = SFSafariViewController(url: myurl!)
        SVC.delegate = self
        present(SVC, animated: true, completion: nil)
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    

    
    //-------------write tap------------------------------------
    @IBAction func writeBarButtonTap(_ sender: Any)
    {
        
        let myAlert = UIAlertController(title: "Write Message", message: nil, preferredStyle: .alert)
        
        myAlert.addTextField { (alertTextfeild) -> Void in
            alertTextfeild.placeholder = "Message"// add place holder text
        }
        
        myAlert.addTextField { (alertTextfeild) -> Void in
            alertTextfeild.placeholder = "Your name"// add place holder text
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        myAlert.addAction(cancelAction)
        
        let addAction = UIAlertAction(title: "Send", style: .default) { (addAction) -> Void in
            
            
            
            let text = (myAlert.textFields![0] as UITextField).text
            let sender = (myAlert.textFields![1] as UITextField).text
            
            
        
                        
            self.addmessage(comeInSting: text!, Sender: sender!)
            
           ref.child("\(self.uuidFromOther)/messages/0000").removeValue()
            
            
            
            self.messageTableView.reloadData()
        }
        myAlert.addAction(addAction)
        
        
        self.present(myAlert, animated: true, completion: nil)
        
        
    }
    //-------------------------------------------------
    
    
    
    //----------------cell for row at index path------------------
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let myCell = messageTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let keys = [String](messages.keys)
        
        
        let key = keys[indexPath.row]
        
        
        let dic = messages[key]!
        
        
        
        
        
        if let text = dic["text"] as? String
        {
            myCell.textLabel?.text = text
            
        }
        
        if let name = dic["sender"] as? String
        {
            
            myCell.detailTextLabel?.text = "From: \(name)"
        }
        
        
        return myCell
    }
    //-----------------------------------------------------
    
    
    //------------------number of rows in section  --------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    //-------------------------------------------------
    
    
    
    
    
    
    
    
    
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
