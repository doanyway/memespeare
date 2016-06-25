//
//  ViewController.swift
//  Memespeare
//
//  Created by James Orzechowski on 1/28/16.
//  Copyright © 2016 James Orzechowski. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ViewController: UIViewController  {

    var templateIds: [String]!
    
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var viewMemeImage: UIImageView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        templateIds = [String]()
        
        self.buttonNext.enabled = false
        let api = ImgFlipController()
        
        var counter = 0
        api.getMemeIds() { responseObject, error in
            if let memeIds = responseObject as? [String] {
                print("\(counter)")
                counter += 1
                print("memeIds = \(memeIds); error = \(error)")
                self.templateIds = memeIds
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.displayRandomMeme()
                    self.buttonNext.enabled = true
                }
                return
            }
        }
    }
    
    
    private func randRange(lower: Int, upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    
    private func getRandomTemplateId() -> Int {
        // fixed bug => upper = count - 1
        let upper: Int = self.templateIds.count - 1
        return randRange(0, upper: upper)
    }
    
    private func displayRandomMeme() {
        let templateId = self.templateIds[getRandomTemplateId()]
        
        captionImage(Int(templateId)!)
    }
    
    
    @IBAction func buttonPressedNext(sender: UIButton) {
        displayRandomMeme()
    }
    

    private func captionImage(templateId: Int) {
        let api = ImgFlipController()
        
        api.captionImage(templateId) { responseObject, error in
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
                            self.viewMemeImage.image = image
                        }
                    }
                }
            }
        }
    }
}

