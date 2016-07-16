//
//  SwipePlayViewController.swift
//  Memespeare
//
//  Created by James Orzechowski on 7/16/16.
//  Copyright © 2016 James Orzechowski. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import RealmSwift


class SwipePlayViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionImage(61579, topCaption: "Hey man")
        
    }
    
    
    private func captionImage(templateId: Int, topCaption: String) {
        let api = ImgFlipController()
        
        api.captionImage(templateId, topCaption: topCaption) { responseObject, error in
            if responseObject == nil {
                let alertController = UIAlertController(title: "Error", message: "Invalid Template ID.", preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // ...
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                    // ...
                }
                return
            }
            if let memeImgURL = responseObject {
                Alamofire.request(.GET, memeImgURL).responseImage { response in
                    if let image = response.result.value {
                        // update imageView
                        dispatch_async(dispatch_get_main_queue()) {
                            self.imageView.image = image
                        }
                    }
                }
            }
        }
    }


    



}
