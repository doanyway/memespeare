//
//  ImgFlipController.swift
//  Memespeare
//
//  Created by James Orzechowski on 2/8/16.
//  Copyright © 2016 James Orzechowski. All rights reserved.
//

import Foundation
import Alamofire

class ImgFlipController {
    
    func getMemeIds(completionHandler: (NSArray?, NSError?) -> ()) {
        makeCall(completionHandler)
    }
    
    
    func makeCall(completionHandler: (NSArray?, NSError?) -> ()) {
        Alamofire.request(.GET, "https://api.imgflip.com/get_memes").responseJSON { response in
            
            var memeList: [String] = []
            
            switch response.result {
            case .Success(let jsonObj):
                
                if let detailsDict = jsonObj as? NSDictionary {
                    
                    if let memeArray = detailsDict["data"]!["memes"] as? NSArray {
                        for var i: Int = 0; i < memeArray.count; i++ {
                            if let oneMemeDict = memeArray[i] as? NSDictionary {
                                if let imgId = oneMemeDict["id"] as? String {
                                    memeList.append(imgId)
                                }
                            }
                        }
                        completionHandler(memeList, nil)
                    }
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
                if let resultDict = jsonObj as? NSDictionary {
                    if let memeImgURL = resultDict["data"]!["url"] as? String {
                        completionHandler(memeImgURL, nil)
                    }
                }
                
            case .Failure(let error):
                print("request failed with error: \(error)")
            }
        }
    }
    
    
}
