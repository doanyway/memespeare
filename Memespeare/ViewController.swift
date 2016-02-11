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

class ViewController: UIViewController {

    var templateIds: [String]
    
    @IBOutlet weak var labelTemplateId: UILabel!
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
                    self.labelTemplateId.text = self.templateIds[self.getRandomTemplateId()]
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
        let upper: Int = self.templateIds.count
        return randRange(0, upper: upper)
    }
    
    @objc @IBAction func buttonPressedNext(sender: UIButton) {
        let templateId = self.templateIds[getRandomTemplateId()]
        self.labelTemplateId.text = templateId
        let api = ImgFlipController()
        
        api.captionImage(Int(templateId)!) { responseObject, error in
            if let memeImgURL = responseObject! as String? {
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

