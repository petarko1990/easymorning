//
//  SpotifyViewController.swift
//  EasyMornig
//
//  Created by Petar Korda on 6/19/17.
//  Copyright © 2017 Cash Me Outside. All rights reserved.
//

import UIKit

protocol SpotifyDelegate {
    func setPlayer(player: SPTAudioStreamingController?)
}

class SpotifyViewController: UIViewController, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
    var spotifyFlag = false
    
    var player: SPTAudioStreamingController?
    var auth = SPTAuth.defaultInstance()!
    var session: SPTSession!
    
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var musicControl: UIStackView!
    @IBOutlet weak var unavailableLabel: UILabel!
    @IBOutlet weak var coverArt: UIImageView!
    
    var spotifyDelegateNews: SpotifyDelegate?
    var spotifyDelegateWeather: SpotifyDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBtn.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (spotifyFlag) {
            
            
            
            if let sessionObj = UserDefaults.standard.object(forKey: "SpotifySession") as AnyObject? {
                let sessionDataObj = sessionObj as! Data
                let currentSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
                
                if currentSession.isValid() {
                    self.session = currentSession
                    initializePlayer(authSession: session)
                    spotifyDelegateNews!.setPlayer(player: player)
                    spotifyDelegateWeather!.setPlayer(player: player)
                } else {
                    performSegue(withIdentifier: "showLogin", sender: self)
                    self.dismiss(animated: true, completion: nil)
                }
                
            } else {
                performSegue(withIdentifier: "showLogin", sender: self)
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            musicControl.isHidden = true
            coverArt.isHidden = true
            unavailableLabel.isHidden = false
            
        }

    }
    
    func startPlayingMusic() {
        if (spotifyFlag) {
            
            playBtn.isHidden = true
            
            if let sessionObj = UserDefaults.standard.object(forKey: "SpotifySession") as AnyObject? {
                let sessionDataObj = sessionObj as! Data
                let currentSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
                
                if currentSession.isValid() {
                    self.session = currentSession
                    initializePlayer(authSession: session)
                } else {
                    performSegue(withIdentifier: "showLogin", sender: self)
                    self.dismiss(animated: true, completion: nil)
                }
                
            } else {
                print("You are not logged in")
            }
        } else {
            musicControl.isHidden = true
            unavailableLabel.isHidden = false
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelPressed(_ sender: Any) {
        if self.player != nil {
            self.player!.logout()
        }
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    func initializePlayer(authSession: SPTSession) {
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            
            self.player!.delegate = self
            
            if !(self.player?.loggedIn)! {
                try! player!.start(withClientId: auth.clientID)
                self.player!.login(withAccessToken: authSession.accessToken)
            }
            
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        try! self.player?.stop()
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        let shufflePos = Int(arc4random_uniform(UInt32(49)))
        
        self.player?.playSpotifyURI("spotify:user:spotifycharts:playlist:37i9dQZEVXbMDoHDwVN2tF", startingWith: UInt(shufflePos), startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                
            }
        })
        
        
    }
    
    
    
    func audioStreamingDidLogout(_ audioStreaming: SPTAudioStreamingController!) {
        try! self.player?.stop()
    }
    
    
    @IBAction func forwardPressed(_ sender: UIButton) {
        self.player?.skipNext({ (error) in
            print(error.debugDescription)
        })
    }
    
    @IBAction func rewindPressed(_ sender: UIButton) {
        self.player?.skipPrevious({ (error) in
            print(error.debugDescription)
        })
    }
    
    
    @IBAction func playPressed(_ sender: UIButton) {
        self.player?.setIsPlaying(true, callback: { (error) in
            print(error.debugDescription)
        })
        pauseBtn.isHidden = false
        playBtn.isHidden = true
    }
    @IBAction func pausePressed(_ sender: UIButton) {
        self.player?.setIsPlaying(false, callback: { (error) in
            print(error.debugDescription)
        })
        pauseBtn.isHidden = true
        playBtn.isHidden = false
    }

}
