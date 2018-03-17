//
//  DetailTabBarController.swift
//  EasyMornig
//
//  Created by Petar Korda on 6/11/17.
//  Copyright © 2017 Cash Me Outside. All rights reserved.
//

import UIKit

class DetailTabBarController: UITabBarController {
    
    var alarmToDisplay: Alarm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newsVC = viewControllers![1] as! NewsViewController
        let weatherVC = viewControllers![2] as! WeatherViewController
        newsVC.getNews = alarmToDisplay!.newsFlag
        weatherVC.forecastForCity = alarmToDisplay?.forcastForCity
        weatherVC.getForecast = alarmToDisplay!.forecastFlag
        let musicVC = viewControllers![0] as! SpotifyViewController
        musicVC.spotifyFlag = (alarmToDisplay?.spotifyFlag)!
        musicVC.spotifyDelegateNews = newsVC
        musicVC.spotifyDelegateWeather = weatherVC
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        
    }
    

}
