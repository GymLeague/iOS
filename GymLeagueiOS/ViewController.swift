//
//  ViewController.swift
//  GymLeagueiOS
//
//  Created by Aditya Maru on 2016-11-07.
//  Copyright © 2016 Aditya Maru. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire

class ViewController: UIViewController {
    var dict : [String : AnyObject]!

    @IBAction func loginButton(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email", "user_friends"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        self.getFBFirends()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    var url = "http://159.203.141.33:51617/api/v1/login"
                    let headers = [
                        "Content-Type" : "application/x-www-form-urlencoded"
                    ]
                    let parameter = ["first_name" : self.dict["name"], "last_name" : self.dict["last_name"], "id" : self.dict["id"], "image" : self.dict["picture"]]
                    //
                    Alamofire.request(url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: headers) .response { (response) in
                        print(response)
                        
                    }
                }
            })
        }
    }
    
    func getFBFirends()
    {
        let params = ["fields": "id, first_name, last_name, middle_name, name, email, picture"]
        let FBRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: params)
        FBRequest?.start(completionHandler: { (connection, result, error) in
            if error != nil
            {
                print("There was an error")
                
            }
            else
            {
                print(result!)
            }
        })
    
    }

}

