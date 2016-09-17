//
//  SwipePlayViewController.swift
//  Memespeare
//
//  Created by James Orzechowski on 7/16/16.
//  Copyright © 2016 James Orzechowski. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift


class SwipePlayViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelActorsLines: UILabel!
    
    var imageURLs = [URL?]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .center
        imageView.image = UIImage.init(named: "download_icon")
        
        imageView.sd_setImage(with: imageURLs.first ?? URL(fileURLWithPath: "")) { _,_,_,_ in
            DispatchQueue.main.async  {
                self.imageView.contentMode = .scaleAspectFit
            }
        }
        
        let cast = uiRealm.objects(Cast.self)
        
        let aLine = uiRealm.objects(PlayLine.self)
        let zeText = aLine[0].actualText
        
        if let romeoID = Int(cast[0].members[0].templateId) {
            if !zeText.isEmpty {
                labelActorsLines.text = zeText
            }
        } else {
            print("did not get romeoId")
        }
        
        print("got past call to realm")
    }
    
    
    
}
