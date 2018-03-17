//
//  SpotifyLoginViewController.swift
//  EasyMornig
//
//  Created by Petar Korda on 6/19/17.
//  Copyright © 2017 Cash Me Outside. All rights reserved.
//

import UIKit

class SpotifyLoginViewController: UIViewController {
    
    var auth = SPTAuth.defaultInstance()!
    var session: SPTSession!
    var loginUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupSpotifyAuth()
        NotificationCenter.default.addObserver(self, selector: #selector(SpotifyLoginViewController.updateAfterFirstLogin), name: Notification.Name(rawValue: "loginSuccessfull"), object: nil)
        
        if let sessionObj = UserDefaults.standard.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let currentSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            
            if currentSession.isValid() {
                self.session = currentSession
                performSegue(withIdentifier: "showMain", sender: self)
            }
            
            
        } else {
            print("You are not logged in")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier=="showMain"){
        
        }
        
    }
    
    func setupSpotifyAuth() {
        SPTAuth.defaultInstance().clientID = "90803cdb28be48a388152e04db6b4ad5"
        SPTAuth.defaultInstance().redirectURL = URL(string: "EasyMorning://returnAfterLogin")
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope]
        loginUrl = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()
    }
    
    func updateAfterFirstLogin() {
        if let sessionObj = UserDefaults.standard.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            
            self.session = firstTimeSession
            
            print("First time login")
            performSegue(withIdentifier: "showMain", sender: self)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        UIApplication.shared.open(loginUrl!, options: [:]) { (ret) in
            if self.auth.canHandle(self.loginUrl!) {
                
            } else {
            
            }
        }
//        if UIApplication.shared.openURL(loginUrl!) {
//            if auth.canHandle(auth.redirectURL) {
//                
//            } else {
//                print("ERROR: can handle redirect")
//            }
//        }
    }
    
    

}
