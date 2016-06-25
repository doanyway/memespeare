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

    var templateIds: [String]
    
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var viewMemeImage: UIImageView!
    
    
    required init?(coder aDecoder: NSCoder) {
        templateIds = [String]()
        super.init(coder: aDecoder)
    }
    
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        templateIds = [String]()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonNext.enabled = false
        let api = ImgFlipController()
        
        api.getMemeIds() { responseObject, error in
            if let memeIds = responseObject as? [String] {
                // print("memeIds = \(memeIds); error = \(error)")
                self.templateIds = memeIds
                
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
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
    
    
    @objc @IBAction func buttonPressedNext(sender: UIButton) {
        let templateId = self.templateIds[getRandomTemplateId()]
        
        captionImage(Int(templateId)!)
        
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
                        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                            self.viewMemeImage.image = image
                        }
                    }
                }
            }
        }
    }
}

