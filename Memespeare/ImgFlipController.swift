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
    
    func getMemeIds(_ completionHandler: @escaping ([String]?, Error?) -> ()) {
        makeCall(completionHandler)
    }
    
    
    func makeCall(_ completionHandler: @escaping ([String]?, Error?) -> ()) {
        Alamofire.request("https://api.imgflip.com/get_memes", method: .get).responseJSON { response in
            
            var memeList: [String] = []
            
            switch response.result {
            case .success(let jsonObj):
                // debugPrint(jsonObj)
                let jsonResult = JSON(jsonObj)
                
                let memeArray = jsonResult["data"]["memes"]
                for i in 0 ..< memeArray.count {
                    let oneMemeDict = memeArray[i]
                    if let imgId:String = oneMemeDict["id"].string {
                        memeList.append(imgId)
                    }
                    
                }
                completionHandler(memeList, nil)
                
            case .failure(let error):
                print("request failed with error: \(error)")
                completionHandler(nil, error)
            }
        }
    }
    
    
    func captionImage(_ templateId: Int, topCaption: String, completionHandler: @escaping (String?, NSError?) -> ()) {
        makeCaptionCall(templateId, topCaption: topCaption, completionHandler: completionHandler)
    }

    func makeCaptionCall(_ templateId: Int, topCaption: String, completionHandler: @escaping (String?, NSError?) -> ()) {
        
        let parameters: [String: AnyObject] = [
            "template_id": templateId as AnyObject,
            "username": "imgflip_hubot" as AnyObject,
            "password": "imgflip_hubot" as AnyObject,
            "text0": topCaption as AnyObject,
            "text1": "" as AnyObject]
        
        Alamofire.request("https://api.imgflip.com/caption_image", method: .post, parameters: parameters).responseJSON { response in
    
            switch response.result {
            case .success(let jsonObj):
                
                let jsonResult = JSON(jsonObj)
                
                if let successInt = jsonResult["success"].number {
                    print("\(successInt)")
                    
                    if successInt == 1 {
                        if let memeImgURL = jsonResult["data"]["url"].string {
                            completionHandler(memeImgURL, nil)
                        }
                    } else {
                        print("got an error")
                        debugPrint(jsonResult)
                        completionHandler(nil, nil)
                    }
                }
                
            case .failure(let error):
                print("request failed with error: \(error)")
            }
        }
    }
    
    
}

