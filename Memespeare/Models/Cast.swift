//
//  Cast.swift
//  Memespeare
//
//  Created by James Orzechowski on 7/2/16.
//  Copyright © 2016 James Orzechowski. All rights reserved.
//

import Foundation
import RealmSwift

class Cast: Object {
    
    dynamic var name = ""
    let members = List<CastMember>()

}
