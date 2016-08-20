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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cast = uiRealm.objects(Cast.self)
        
        let aLine = uiRealm.objects(PlayLine.self)
        let zeText = aLine[0].actualText
        
        if let romeoID = Int(cast[0].members[0].templateId) {
            if !zeText.isEmpty {
                captionImage(romeoID, topCaption: zeText)
            }
        } else {
            print("did not get romeoId")
        }
        
        print("got past call to realm")
    }
    
    
    private func captionImage(templateId: Int, topCaption: String) {
        let api = ImgFlipController()
        
        api.captionImage(templateId, topCaption: topCaption) { responseObject, error in
            
            guard let memeImgURL = responseObject where error == nil else {
                
                let alertController = UIAlertController(title: "Error", message: "Invalid Template ID.", preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // ...
                }
                alertController.addAction(OKAction)
                
                dispatch_async(dispatch_get_main_queue())  {
                    self.presentViewController(alertController, animated: true) {
                    }
                }
                return
            }
            
            self.imageView.contentMode = .Center
            self.imageView.sd_setImageWithURL(NSURL(string: memeImgURL), placeholderImage: UIImage.init(named: "download_icon")) { _,_,_,_ in
                dispatch_async(dispatch_get_main_queue())  {
                    self.imageView.contentMode = .ScaleAspectFit
                }
            }
            
        }
    }
    
    
}
