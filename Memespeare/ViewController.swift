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
import RealmSwift

class ViewController: UIViewController  {

    var templateIds: [String]!
    
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var viewMemeImage: UIImageView!
    @IBOutlet weak var chooseCast: UILabel!
    
    var cast: Cast!
    
    let castPrompt = ["Is this Romeo?", "Is this Juliet?", "Is this the Nurse?"]
    
    var currentTemplateId: String = ""
    
    var currentIndex = 0
    
    let possibleRomeos = [101470, 563423, 245898]
    let possibleJuliets = [61539, 14230520, 28251713]
    let possibleNurses = [100955, 8072285, 405658]
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        populateCast()
        currentIndex = 0
        
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
                    
                    self.currentTemplateId = "\(self.possibleRomeos[0])"
                    self.displaySpecificMeme(self.possibleRomeos[0])
                    self.buttonNext.enabled = true
                    self.chooseCast.text = self.castPrompt[self.currentIndex]
                }
                return
            }
        }
    }
    
    
    private func populateCast() {
    
        let romeo = CastMember()
        romeo.name = "Romeo"
        
        let juliet = CastMember()
        juliet.name = "Juliet"
        
        let nurse = CastMember()
        nurse.name = "The Nurse"
        
        try! uiRealm.write({ () -> Void in
            uiRealm.add(romeo)
            uiRealm.add(juliet)
            uiRealm.add(nurse)

        })

        let cast = Cast()
        cast.name = "Romeo and Juliet"
        
        try! uiRealm.write({ () -> Void in
            uiRealm.add(cast)
            cast.members.append(romeo)
            cast.members.append(juliet)
            cast.members.append(nurse)
        })
    }
    
    
    private func randRange(lower: Int, upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    
    private func getRandomTemplateId() -> Int {
        // fixed bug => upper = count - 1
        let upper: Int = self.templateIds.count - 1
        return randRange(0, upper: upper)
    }
    
    private func displayRandomMeme() -> String {
        let templateId = self.templateIds[getRandomTemplateId()]
        
        captionImage(Int(templateId)!)
        return templateId
    }
    
    
    private func displaySpecificMeme(templateId: Int) -> Int {
        
        captionImage(templateId)
        return templateId
    }

    
    private func displayCast() {
        
        var actualId: Int = 61533
        
        if currentIndex == 0 {
            actualId = displaySpecificMeme(possibleRomeos[Int(arc4random_uniform(UInt32(possibleRomeos.count)))])
        } else if currentIndex == 1 {
            actualId = displaySpecificMeme(possibleJuliets[Int(arc4random_uniform(UInt32(possibleJuliets.count)))])
        } else if currentIndex == 2 {
            actualId = displaySpecificMeme(possibleNurses[Int(arc4random_uniform(UInt32(possibleNurses.count)))])
        }
        
        self.currentTemplateId = "\(actualId)"
        print(self.currentTemplateId)
    }
    
    
    @IBAction func buttonPressedNext(sender: UIButton) {
        displayCast()
    }
    
    
    @IBAction func buttonPressedYes(sender: AnyObject) {
        
        let cast = uiRealm.objects(Cast.self)
        
        let count = cast[0].members.count
        
        if currentIndex < count {
            
            try! uiRealm.write({ () -> Void in
                // print("in realm write: " + self.currentTemplateId)
                cast[0].members[currentIndex].templateId = self.currentTemplateId
            })
            
            currentIndex += 1

            if currentIndex < count {
                self.chooseCast.text = castPrompt[currentIndex]
                self.displayCast()
            } else {
                switchScreen()
            }
        }
    }
    
    
    func switchScreen() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : SwipePlayViewController = mainStoryboard.instantiateViewControllerWithIdentifier("SwipePlay") as! SwipePlayViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    

    private func captionImage(templateId: Int) {
        let api = ImgFlipController()
        
        api.captionImage(templateId, topCaption: ".") { responseObject, error in
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

