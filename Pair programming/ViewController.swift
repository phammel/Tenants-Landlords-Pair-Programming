//
//  ViewController.swift
//  Pair programming
//
//  Created by Phammel on 3/8/17.
//  Copyright © 2017 Phammel. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var houseTableView: UITableView!
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var shouldAdvance = false
    
    var houseHolds = [String: [String: Any]]()
    
     var TimTimer = Timer()
    
    
    var uuidToSave = ""
    

    //--------------- view did load ---------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        ref.observeSingleEvent(of: .value, with:
        { (snap) in
            if let value = snap.value as? [String: [String: Any]]
            {
               
                let names = [String](value.keys)
                
                for name in names
                {
                    let dict = value[name]!
                    self.houseHolds[name] = dict
                }
                self.houseTableView.reloadData()
            }
        })
        
        TimTimer = Timer.scheduledTimer(timeInterval: 12, target: self, selector: #selector(timeUpdate), userInfo: nil, repeats: true)
        
    }
    //--------------------------------------------------
    //-------------- time update ----------------------
    func timeUpdate()
    {
    
        ref.observe(.value, with:
            { (snap) in
              
                if let value = snap.value as? [String: [String: Any]]
                {
                    
                     let names = [String](value.keys)
                     
                     for name in names
                     {
                     let dict = value[name]!
                     self.houseHolds[name] = dict
                     }
                }
        })
        
        self.houseTableView.reloadData()
    }
    //---------------------------------------------------

    
    //----------add tapped --------------------------
    
    @IBAction func addBarButtonTap(_ sender: Any)
    {
        
        
        let myAlert = UIAlertController(title: "Add House", message: nil, preferredStyle: .alert)
        myAlert.addTextField { (alertTextfeild) -> Void in
            alertTextfeild.placeholder = "Address"// add place holder text
        }
        myAlert.addTextField { (alertTextfeild) -> Void in
            alertTextfeild.placeholder = "Password"// add place holder text

            alertTextfeild.isSecureTextEntry = true
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        myAlert.addAction(cancelAction)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (addAction) -> Void in
        
            
            //boi
            let address = (myAlert.textFields![0] as UITextField).text
            let password = (myAlert.textFields![1] as UITextField).text
            
            
            
            
            let firstmasagedata = ["text": "Welcome", "sender": "System"]
            
            let messages = ["0000": firstmasagedata]
            
            
            let newDic = ["address": address!, "password": password, "messages": messages] as [String : Any]
            
            
            
            let ID = UUID().uuidString
            
            set(newDic, forKey: ID)
            
            self.houseHolds[ID] = newDic
            
            
            self.houseTableView.reloadData()
        }
        myAlert.addAction(addAction)
        
        
        self.present(myAlert, animated: true, completion: nil)
  
    }
    
    //---------------------------------------------------------
    
    
    //----------------cell for row at index path------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let myCell = houseTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let keys = [String](houseHolds.keys)
        
       
        let key = keys[indexPath.row]
        
        
        let dic = houseHolds[key]!
        
        
      
        
        if let address = dic["address"] as? String
        {
            myCell.textLabel?.text = address
        }
        
        
        return myCell
    }
    //-----------------------------------------------------
    
    
    //------------------number of rows in section  --------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return houseHolds.count
    }
    
    //-------------------------------------------------
    
    
    
    
    
    
    //---------------------did select------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let keys = [String](houseHolds.keys)
        
        let key = keys[indexPath.row]
        
        let dic = houseHolds[key]!
        
        let password = dic["password"] as? String
        

        let myAlert = UIAlertController(title: "Enter Password", message: nil, preferredStyle: .alert)
        
        myAlert.addTextField { (alertTextfeild) -> Void in
            alertTextfeild.placeholder = "Password"// add place holder text
            
            alertTextfeild.isSecureTextEntry = true
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        myAlert.addAction(cancelAction)
       
        
        let addAction = UIAlertAction(title: "Enter", style: .default) { (addAction) -> Void in
            
        
            let Enteredpassword = (myAlert.textFields![0] as UITextField).text
            
          
            
            if "\(password)" == "\(Enteredpassword)"
            {
                self.uuidToSave = key
                self.performSegue(withIdentifier: "GoToNext", sender: self)
                
            }
            else
            {
                self.uuidToSave = ""
                let theAlert = UIAlertController(title: "Incorrect Password", message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                theAlert.addAction(cancelAction)
                self.present(theAlert, animated: true, completion: nil)
                
            }
            
        }
        myAlert.addAction(addAction)
        self.present(myAlert, animated: true, completion: nil)

        
        
        
        
        
    }
  //----------------------------------------------------------
    
    

    
    // ------------------- Segue -----------------------------------------------------
    
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        let detailview = segue.destination as! MessageViewController
        
        detailview.uuidFromOther = self.uuidToSave
        
        
    }
 
    
// ------------------------------------------------------------------------
    
    
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

