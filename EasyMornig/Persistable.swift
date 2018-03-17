//
//  Persistable.swift
//  EasyMornig
//
//  Created by Petar Korda on 6/10/17.
//  Copyright © 2017 Cash Me Outside. All rights reserved.
//

import Foundation

protocol Persistable {
    var ud: UserDefaults {get}
    var persistKey : String {get}
    func persist()
    func unpersist()
}
