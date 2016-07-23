//
//  PlayLine.swift
//  Memespeare
//
//  Created by James Orzechowski on 7/16/16.
//  Copyright © 2016 James Orzechowski. All rights reserved.
//

import Foundation
import RealmSwift

class PlayLine: Object {
    
    dynamic var act = 0
    dynamic var scene = 0
    dynamic var line = 0
    dynamic var actualText = ""
    dynamic var castMember: CastMember!
    
}
