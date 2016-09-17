//
//  ViewController.swift
//  Memespeare
//
//  Created by James Orzechowski on 1/28/16.
//  Copyright © 2016 James Orzechowski. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import SDWebImage

class ViewController: UIViewController  {
    
    var templateIds: [String]!
    
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var viewMemeImage: UIImageView!
    @IBOutlet weak var chooseCast: UILabel!
    
    // TODO: make private
    var cast: Cast!
    
    let castPrompt = ["Is this Romeo?", "Is this Juliet?", "Is this the Nurse?"]
    
    var currentTemplateId: String = ""
    
    var currentIndex = 0
    
    var tempURL = [URL?]()
    

    
    let possibleRomeos = [101470, 563423, 245898, 100947, 40945639, 101716, 14371066, 40945639, 124212]
    let possibleJuliets = [61539, 14230520, 28251713, 97984, 61556]
    let possibleNurses = [100955, 8072285, 405658]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        
        
        populateCast()
        currentIndex = 0
        
        templateIds = [String]()
        
        self.buttonNext.isEnabled = false
        let api = ImgFlipController()
        
        var counter = 0
        api.getMemeIds() { responseObject, error in
            if let memeIds = responseObject {
                print("\(counter)")
                counter += 1
                print("memeIds = \(memeIds); error = \(error)")
                self.templateIds = memeIds
                
                DispatchQueue.main.async {
                    
                    self.chooseCastMembers()
                }
                return
            }
        }
    }

    
    fileprivate func chooseCastMembers() {
        
        currentTemplateId = "\(self.possibleRomeos[0])"
        displaySpecificMeme(self.possibleRomeos[0])
        buttonNext.isEnabled = true
        chooseCast.text = self.castPrompt[self.currentIndex]
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        if templateIds.count > 0 {
            tempURL.removeAll()
            currentIndex = 0
            chooseCastMembers()
        }
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [.portrait]
    }
    
    
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    
    fileprivate func populateCast() {
        
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
    
    
    fileprivate func randRange(_ lower: Int, upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    
    fileprivate func getRandomTemplateId() -> Int {
        // fixed bug => upper = count - 1
        let upper: Int = self.templateIds.count - 1
        return randRange(0, upper: upper)
    }
    
    fileprivate func displayRandomMeme() -> String {
        let templateId = self.templateIds[getRandomTemplateId()]
        
        captionImage(Int(templateId)!)
        return templateId
    }
    
    
    fileprivate func displaySpecificMeme(_ templateId: Int) -> Int {
        
        captionImage(templateId)
        return templateId
    }
    
    
    fileprivate func displayCast() {
        
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
    
    
    @IBAction func buttonPressedNext(_ sender: UIButton) {
        displayCast()
    }
    
    
    @IBAction func buttonPressedYes(_ sender: AnyObject) {
        
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
        performSegue(withIdentifier: String(describing: SwipePlayViewController.self), sender: self)
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//        let vc : SwipePlayViewController = mainStoryboard.instantiateViewControllerWithIdentifier("SwipePlay") as! SwipePlayViewController
//        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SwipePlayViewController {
            destination.imageURLs = tempURL as [URL?]
        }
    }
    
    
    fileprivate func captionImage(_ templateId: Int) {
        let api = ImgFlipController()
        
        api.captionImage(templateId, topCaption: " ") { responseObject, error in
            
            guard let memeImgURL = responseObject , error == nil else {
                
                let alertController = UIAlertController(title: "Error", message: "Invalid Template ID.", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // ...
                }
                alertController.addAction(OKAction)
                
                DispatchQueue.main.async  {
                    self.present(alertController, animated: true) {
                }
                }
                return
            }
            self.tempURL.append(URL(string: memeImgURL))
            
            self.viewMemeImage.contentMode = .center
            
            self.viewMemeImage.image = UIImage.init(named: "download_icon")
            
            self.viewMemeImage.sd_setImage(with: URL(string: memeImgURL))
     { _,_,_,_ in
                DispatchQueue.main.async  {
                    self.viewMemeImage.contentMode = .scaleAspectFill
                }
            }
        }
    }
}

