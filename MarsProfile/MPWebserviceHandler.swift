//
//  MPWebserviceHandler.swift
//  MarsProfile
//
//  Created by TechMadmin on 01/08/17.
//  Copyright © 2017 com.mars.MarsProfile. All rights reserved.
//

import UIKit
import AFNetworking
private let firstName = "{firstname}"
private let lastName = "{lastname}"

class MPWebserviceHandler: NSObject {
    static var sMPWebserviceHandler:MPWebserviceHandler = MPWebserviceHandler()
    
    let kMISImageCompressionQuality:CGFloat = 0.8
    let kMISImageMaxSize:CGFloat = 2048.0
    weak var initiatedByController :UIViewController?
    
    private let kOutlookCurrentProfileURL = "https://graph.microsoft.com/v1.0/me/"
    private let kYammerCurrentProfileURL = "https://www.yammer.com/api/v1/users/current.json?include_group_memberships=true"
    private let kProfileImageToYammerURL = "https://www.yammer.com/mugshot/images/"
    private let kProfileImageUploadOutlookURL = "https://graph.microsoft.com/v1.0/me/photo/$value"
    private let kProfileImageURL = "https://graph.microsoft.com/v1.0/me/photo/$value"
    private let kYammerCurrentUserURL = "https://www.yammer.com/api/v1/users/current.json?include_group_memberships=true"
    
    private let kSharePointImageURL = "https://mydrive.effem.com:443/User%20Photos/Profile%20Pictures/\(firstName)_\(lastName)_effem_com_LThumb.jpg?t%3D63638648262"
    private let kStickersFromSharepointURL = ""
    private var restClientForOutlook:MISADALRestClient = MISADALRestClient.forOutlook()
    private var restClientForYammer:MISADALRestClient = MISADALRestClient.forYammer()
    var restClientForSharePoint:MISADALRestClient = MISADALRestClient.forSharePoint()
    private var mImageToUpload:UIImage?
    private var mOutlookUserId:String?
    private var mYammerUserId:String?
    private var mYammerImageId:String?
    private var mYMAPIClient :YMAPIClient?
    private var yammerMugShotURL:String = "https://www.yammer.com/mugshot/images/"
  
    func uploadImageToSources(isImageUploadToYammer:Bool,isImageUploadToOutlook:Bool, imageToUpload:UIImage, completionHandler completion:((Bool, Bool, Error?, Error?) -> Void)!){
        let downloadGroup:DispatchGroup = DispatchGroup.init()
        var isUploadedToOutlook = true
        var isUploadedToYammer = true
        var errorForOutlook:Error?
        var errorForYammer:Error?
        mImageToUpload = imageToUpload
        UIImageWriteToSavedPhotosAlbum(mImageToUpload!, nil, nil, nil);
        if(isImageUploadToOutlook){
            isUploadedToOutlook = false
            downloadGroup.enter()
            fetchOutlookProfile({ (result: Any?, error:Error?) in
                
                if(error == nil){
                    self.uploadProfileImageToOutlook(self.mImageToUpload!, completionHandler: { (result: Any?, error:Error?) in
                        if(error == nil){
                            isUploadedToOutlook = true
                            downloadGroup.leave()
                        }else{
                            errorForOutlook = error
                            isUploadedToOutlook = false
                            downloadGroup.leave()
                        }
                    })
                }else{
                    errorForOutlook = error
                    isUploadedToOutlook = false
                    downloadGroup.leave()
                }
            })
        }
        if(isImageUploadToYammer){
            isUploadedToYammer = false
            downloadGroup.enter()
            fetchYammerProfile({ (result: Any?, error:Error?) in
                errorForYammer = error
                if(error == nil){
                    isUploadedToYammer = true
                    downloadGroup.leave()
                }else{
                    isUploadedToYammer = false
                    downloadGroup.leave()
                }
            })
        }
        
        downloadGroup.notify(queue: DispatchQueue.global()) {
            completion(isUploadedToYammer, isUploadedToOutlook, errorForYammer, errorForOutlook)
        }
    }
    func setImageForUploading(_ imageTo :UIImage) ->UIImage{
        let size = imageTo.size
        let targetSize = CGSize(width: 240.0, height: 240.0)
        let widthRatio  = targetSize.width  / imageTo.size.width
        let heightRatio = targetSize.height / imageTo.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        imageTo.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    // MARK: Outlook
    func fetchOutlookProfile(_ completion:((Any?, Error?) -> Void)!){
        UserDefaults.standard.synchronize()
        let userId = UserDefaults.standard.string(forKey: kLoggedInUserIdKey)
        let displayName = UserDefaults.standard.string(forKey: kLoggedInUserKey)
        let firstName = UserDefaults.standard.string(forKey: kUserFirstNameKey)
        let lastName = UserDefaults.standard.string(forKey: kUserLastNameKey)
        if(userId != nil && ((firstName != nil && firstName != "") || (lastName != nil && firstName != ""))){
            self.mOutlookUserId = userId
            let resultDict:NSDictionary = NSDictionary(dictionary: ["displayName" : displayName ?? "", "id":userId!, "surname": lastName ?? "", "givenName":firstName ?? ""])
            completion(resultDict, nil)
        } else {
            restClientForOutlook.getJsonWith(URL(string:kOutlookCurrentProfileURL)!, jsonObjectClass: NSDictionary.classForCoder(), withOdata:false , completionHandler: { (result: Any?, error:Error?) in
                if(error == nil){
                    let resultedDict = (result as! NSDictionary)
                    self.mOutlookUserId = resultedDict.object(forKey: "id") as? String
                }
                completion(result, error)
            })
        }
    }
    
    func uploadProfileImageToOutlook(_ imageToUpload:UIImage,completionHandler completion:((Any?, Error?) -> Void)!){
        let imageData = UIImageJPEGRepresentation(imageToUpload, kMISImageCompressionQuality)
        let uploadURL = kProfileImageUploadOutlookURL
        restClientForOutlook.putDataObject(imageData, with: URL(string : uploadURL), completionHandler: { (error:Error?) in
            completion(nil,error)
        })
    }
    // MARK: Yammer
    func fetchYammerProfile(_ completion:((Any?, Error?) -> Void)!){
        mYMAPIClient = YMAPIClient.init(authToken: YMLoginClient.sharedInstance().storedAuthToken())
        mYMAPIClient?.getPath("/api/v1/users/current.json", parameters: nil, success: { (result:Any?) in
            let resultedDict = (result as? NSDictionary)
            if(resultedDict != nil){
                self.mYammerUserId = String(resultedDict?.object(forKey: "id") as! Int32)
                self.uploadProfileImageToYammer(completion)
            }else{
                completion(result, nil)
            }
        }, failure: { (error: Error) in
            print("Error -- \(error)")
            completion(nil, error)
        })
    }

    func uploadProfileImageToYammer(_ completion:((Any?, Error?) -> Void)!){
        let imageData = UIImageJPEGRepresentation(mImageToUpload!, kMISImageCompressionQuality);
        mYMAPIClient?.postPath("/mugshot/images/", constructingBodyWith: {(_ formData: AFMultipartFormData) -> Void in
            formData.appendPart(withFileData: imageData!, name: "image", fileName: "userpicture.jpeg", mimeType: "image/jpeg")
        }, parameters: nil, success: {(_ responseObj: Any) -> Void in
            print("Success")
            let resultedDict = (responseObj as? NSDictionary)
            if(resultedDict != nil){
            self.mYammerImageId = resultedDict?["image_id"] as? String
            self.uploadProfileImageIdentifierToYammer(completionHandler: completion)
            }else{
                completion(nil, nil)
            }
        }, failure: {(_ statusCode: Int, _ error: Error?) -> Void in
            print("failure")
            completion(nil, error)
        })
    }
    
    func uploadProfileImageIdentifierToYammer(completionHandler completion:((Any?, Error?) -> Void)!){
        mYMAPIClient?.putPath("/api/v1/users/\(self.mYammerUserId!).json", parameters: ["mugshot_id": self.mYammerImageId!], success: {(_ responseObject: Any?) -> Void in
            print("Success uploadProfileImageIdentifierToYammer")
            completion(responseObject, nil)
        }, failure: {(_ error: Error?) -> Void in
            print("Failure uploadProfileImageIdentifierToYammer")
            completion(nil, error)
        })
    }
    // MARK: To Download profile Image
    func downloadProfileImage(completionHandler completion:((UIImage?, Error?) -> Void)!){
        restClientForOutlook.getImageWith(URL(string:kProfileImageURL), completionHandler: { (result:Any?,error: Error?) in
            let imageFromResult = result as? UIImage
            if(error == nil && imageFromResult != nil){//
                completion(imageFromResult, nil)
            }else{
                self.downloadProfileImageFromYammer(completionHandler: completion)
            }
        })
    }
    
    private func downloadProfileImageFromYammer(completionHandler completion:((UIImage?, Error?) -> Void)!){
        
        // Fetch the profile Pic from the yammer
        restClientForYammer.getJsonWith(URL(string:self.kYammerCurrentUserURL)!, jsonObjectClass: NSDictionary.classForCoder(), withOdata:false , completionHandler: { (result: Any?, error:Error?) in
            if(error == nil && result != nil){
                let resultedDict = (result as! NSDictionary)
                var mugshotURL:String = (resultedDict.value(forKey: "mugshot_url_template") as! String)
                let imageDimension:Int
                if(Display.typeIsLike == DisplayType.iphone5){
                    imageDimension = 182
                }else{
                    imageDimension = 240
                }
                mugshotURL = mugshotURL.replacingOccurrences(of: "{width}", with: "\(imageDimension)")
                mugshotURL = mugshotURL.replacingOccurrences(of: "{height}", with: "\(imageDimension)")
                 self.restClientForYammer.getImageWith(URL(string:mugshotURL), completionHandler: {(result:Any?,error: Error?) in
                    let imageFromResult = result as? UIImage
                    if(error == nil && imageFromResult != nil){
                        completion(imageFromResult, nil)
                    }
                    else {
                        print("Error from Yammer")
                        self.downloadProfileImageFromSharePoint(completionHandler: completion)
                    }
                })
            } else {
                print("Error from Yammer")
                self.downloadProfileImageFromSharePoint(completionHandler: completion)
            }
        })
    }
    
    private func downloadProfileImageFromSharePoint(completionHandler completion:((UIImage?, Error?) -> Void)!){
        let userFirstName = UserDefaults.standard.string(forKey:kUserFirstNameKey)
        let userlastName = UserDefaults.standard.string(forKey:kUserLastNameKey)
        
        var sharepointURL:String = self.kSharePointImageURL
        sharepointURL = sharepointURL.replacingOccurrences(of: firstName, with: userFirstName!)
        sharepointURL = sharepointURL.replacingOccurrences(of: lastName, with: userlastName!)
        restClientForSharePoint.getImageWith(MISADALRestClient.urlForUserProfilePicture(with: URL(string:sharepointURL)), completionHandler: {(result:Any?,error: Error?) in
            let imageFromResult = result as? UIImage
            if(error == nil && imageFromResult != nil){//
                completion(result as? UIImage, nil)
            }
            else {
                print("Error on sharepoint")
                completion(nil, nil)
            }
        })
    }
}
