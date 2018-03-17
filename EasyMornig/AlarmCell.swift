//
//  AlarmCellCollectionViewCell.swift
//  EasyMornig
//
//  Created by Petar Korda on 6/10/17.
//  Copyright © 2017 Cash Me Outside. All rights reserved.
//

import UIKit

class AlarmCell: UICollectionViewCell {
    
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var newsIcon: UIImageView!
    @IBOutlet weak var weatherIcon: UIImageView!    
    @IBOutlet weak var musicIcon: UIImageView!
    
    
    func setAlarmTime(date: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let formatedDate = dateFormatter.string(from: date)
        
        
        let amAttr: [String : Any] = [NSFontAttributeName : UIFont.systemFont(ofSize: 20.0)]
        let str = NSMutableAttributedString(string: formatedDate, attributes: amAttr)
        let timeAttr: [String : Any] = [NSFontAttributeName : UIFont.systemFont(ofSize: 45.0)]
        str.addAttributes(timeAttr, range: NSMakeRange(0, str.length-2))
        timeLabel.attributedText = str
    }
    
    func updateShowingIcons(news: Bool, weather: Bool, music: Bool) {
        //add code for hidding and showing
        newsIcon.isHidden = !news
        weatherIcon.isHidden = !weather
        musicIcon.isHidden = !music
    }
    
    
    
    
}
