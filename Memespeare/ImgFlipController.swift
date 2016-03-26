//
//  ImgFlipController.swift
//  Memespeare
//
//  Created by James Orzechowski on 2/8/16.
//  Copyright © 2016 James Orzechowski. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class ImgFlipController {
    
    func getMemeIds(completionHandler: (NSArray?, NSError?) -> ()) {
        makeCall(completionHandler)
    }
    
    
    func makeCall(completionHandler: (NSArray?, NSError?) -> ()) {
        Alamofire.request(.GET, "https://api.imgflip.com/get_memes").responseJSON { response in
            
            var memeList: [String] = []
            
            switch response.result {
            case .Success(let jsonObj):
                
                let swifty = JSON(jsonObj)
                
                let memeArray = swifty["data"]["memes"]
                for i in 0 ..< memeArray.count {
                    let oneMemeDict = memeArray[i]
                    if let imgId:String = oneMemeDict["id"].string {
                        memeList.append(imgId)
                    }
                    completionHandler(memeList, nil)
                }
                
            case .Failure(let error):
                print("request failed with error: \(error)")
                completionHandler(nil, error)
            }
        }
    }
    
    
    func captionImage(templateId: Int, completionHandler: (String?, NSError?) -> ()) {
        makeCaptionCall(templateId, completionHandler: completionHandler)
    }

    func makeCaptionCall(templateId: Int, completionHandler: (String?, NSError?) -> ()) {
        
        let parameters: [String: AnyObject] = [
            "template_id": templateId,
            "username": "imgflip_hubot",
            "password": "imgflip_hubot",
            "text0": "O Romeo, Romeo! wherefore art thou Romeo?",
            "text1": ""]
        
        Alamofire.request(.POST, "https://api.imgflip.com/caption_image", parameters: parameters).responseJSON { response in
    
            switch response.result {
            case .Success(let jsonObj):
                
                let swifty = JSON(jsonObj)
                
                if let successInt = swifty["success"].number {
                    print("\(successInt)")
                    
                    if successInt == 1 {
                        if let memeImgURL = swifty["data"]["url"].string {
                            completionHandler(memeImgURL, nil)
                        }
                    } else {
                        print("got an error")
                        debugPrint(swifty)
                        completionHandler(nil, nil)
                    }
                }
                
            case .Failure(let error):
                print("request failed with error: \(error)")
            }
        }
    }
    
    
}

