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

class ViewController: UIViewController, UITextFieldDelegate {

    var templateIds: [String]
    
    @IBOutlet weak var labelTemplateId: UILabel!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var viewMemeImage: UIImageView!
    
    @IBOutlet weak var textFieldTemplateId: UITextField!
    @IBOutlet weak var buttonIncrementTemplateId: UIButton!
    @IBOutlet weak var buttonCreateMeme: UIButton!
    
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
        
        textFieldTemplateId.delegate = self
        
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textFieldTemplateId.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        doSomeTask()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
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
        
        captionImage(Int(templateId)!)
        
    }
    
    @objc @IBAction func buttonPressedIncrement(sender: UIButton) {
        
    }
    
    private func doSomeTask() {
        print("when done editing get here too")
        
        if let text: String = textFieldTemplateId.text {
            print("\(text)")
        }
    }
    
    @objc @IBAction func buttonPressedCreateMeme(sender: UIButton) {
        
        print("pressed create meme")
        doSomeTask()
        
        // TODO: only call captionImage if an int
        
        
        /*
        guard let text = textFieldTemplateId.text where !text.isEmpty else {
            return
        }
        */

        
        
        /*
        if let templateId: Int = Int(self.textFieldTemplateId.text) as? Int {
            print("got a number: \(templateId)")
        }
        */
    }
    
    private func captionImage(templateId: Int) {
        let api = ImgFlipController()
        
        api.captionImage(templateId) { responseObject, error in
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

