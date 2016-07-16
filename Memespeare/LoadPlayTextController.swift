//
//  LoadPlayTextController.swift
//  Memespeare
//
//  Created by James Orzechowski on 7/16/16.
//  Copyright © 2016 James Orzechowski. All rights reserved.
//

import Foundation
import RealmSwift


class LoadPlayTextController {
    
    func populateSomeLines() {
        
        print("populate some lines")
        
        let aLine = PlayLine()
        
        try! uiRealm.write({ () -> Void in
            uiRealm.add(aLine)
        })
        
        try! uiRealm.write({ () -> Void in
            aLine.act = 2
            aLine.scene = 2
            aLine.line = 2
            aLine.actualText = "But soft! What light through yonder window breaks?"
        })
        
    }
}
