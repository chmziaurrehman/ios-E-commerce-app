//
//  WebServiceManager.swift
//  Thoubk
//
//  Created by Nouman Tariq on 9/7/16.
//  Copyright © 2016 ilsainteractive. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SVProgressHUD

class WebServiceManager: NSObject {
    
    static var serviceCount = 0
   class func progressHudSetting()  {
        SVProgressHUD.setCornerRadius(40)
        SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.767985026))
        SVProgressHUD.setForegroundColor(UIColor.init(named: "blueberry")!)
        SVProgressHUD.setBorderColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        SVProgressHUD.setBorderWidth(1)
    }
    
    class func get<T: AnyObject>(params: Dictionary<String, AnyObject>?, serviceName: String, header: Dictionary<String, String>, serviceType: String, modelType: T.Type, success: @escaping (_ servicResponse: AnyObject) -> Void, fail: @escaping (_ error: NSError) -> Void) where T: Mappable {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 1
        SVProgressHUD.show()
        progressHudSetting()
        showNetworkIndicator()
        
        Alamofire.request(serviceName, method: .get, encoding: JSONEncoding.default, headers: header).responseObject { (response: DataResponse<T>) in
            hideNetworkIndicator()
    
            switch response.result {
            case .success(let objectData):
//                print(objectData)
                SVProgressHUD.dismiss()
                success(objectData)
                break
            case .failure(let error):
                SVProgressHUD.dismiss()
                if error.localizedDescription == "The Internet connection appears to be offline." {
                    APIManager.sharedInstance.customPOP(isError: true, message: "The Internet connection appears to be offline.")
                }
                fail(error as NSError)
                print(error.localizedDescription)
            }
        }
    }
    
    class func post123<T: AnyObject>(params: Dictionary<String, AnyObject>, serviceName: String, header: Dictionary<String, String>, serviceType: String, modelType: T.Type, success: @escaping ( _ servicResponse: AnyObject) -> Void, fail: @escaping ( _ error: NSError) -> Void, showHUD: Bool)  where T: Mappable {
        
        if showHUD {
            SVProgressHUD.show()
            progressHudSetting()
        }
        
//        let manager = Alamofire.SessionManager.default
//        manager.session.configuration.timeoutIntervalForRequest = 0
//
        showNetworkIndicator()

//        print("Service Name (API) :  \(serviceName)")
//        print("Input parms (API) :  \(params)")
//        print("header (API) :   \(header)")
//        
        
        Alamofire.request(serviceName, method: .post, parameters: params, encoding: JSONEncoding.default)
//        Alamofire.request(serviceName, method:.post, parameters: params, headers: header)
            .validate()
            .responseObject { (response: DataResponse<T>) in
                
                hideNetworkIndicator()
                
                switch response.result {
                    
                case.success(let objectData):
                    print(response.result)
                    SVProgressHUD.dismiss()
                    success(objectData)
                case.failure(let error):
                    print(error.localizedDescription)
                    SVProgressHUD.dismiss()
                    fail(error as NSError)
                }
        }
    }
    class func post<T: AnyObject>(params: Dictionary<String, AnyObject>, serviceName: String, header: Dictionary<String, String>, serviceType: String, modelType: T.Type, success: @escaping ( _ servicResponse: AnyObject) -> Void, fail: @escaping ( _ error: NSError) -> Void, showHUD: Bool)  where T: Mappable {
        
        if showHUD {
            SVProgressHUD.show()
            progressHudSetting()
        }
        
//        let manager = Alamofire.SessionManager.default
//        manager.session.configuration.timeoutIntervalForRequest = 0
//
        showNetworkIndicator()
        
        print("Service Name (API) :  \(serviceName)")
        print("Input parms (API) :  \(params)")
        print("header (API) :   \(header)")
        Alamofire.request(serviceName, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header)
            //        Alamofire.request(serviceName, method:.post, parameters: params, headers: header)
            .validate()
            .responseObject { (response: DataResponse<T>) in
                
                hideNetworkIndicator()
           
                switch response.result {
                    
                case.success(let objectData):
                    print(response.result)
                    
                    SVProgressHUD.dismiss()
                    success(objectData)
                case.failure(let error):
                    print(error.localizedDescription)
                    SVProgressHUD.dismiss()
                    fail(error as NSError)
                }
        }
    }
    
    class func poost<T: AnyObject>(params: Dictionary<String, AnyObject>, serviceName: String, header: Dictionary<String, String>, serviceType: String, modelType: T.Type, success: @escaping ( _ servicResponse: AnyObject) -> Void, fail: @escaping ( _ error: NSError) -> Void, showHUD: Bool)  where T: Mappable {
        
        if showHUD {
            SVProgressHUD.show()
           progressHudSetting()
        }
//
//        let manager = Alamofire.SessionManager.default
//        manager.session.configuration.timeoutIntervalForRequest = 0
//
        showNetworkIndicator()
        
        print("Service Name (API) :  \(serviceName)")
        print("Input parms (API) :  \(params)")
//        print("header (API) :   \(header)")
        Alamofire.request(serviceName, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: header)
            //        Alamofire.request(serviceName, method:.post, parameters: params, headers: header)
            .validate()
            .responseObject { (response: DataResponse<T>) in
                hideNetworkIndicator()
       
                switch response.result {
                case.success(let objectData):
//                    print(response.result)
                    SVProgressHUD.dismiss()
                    success(objectData)
                case.failure(let error):
                    print(error.localizedDescription)
                    SVProgressHUD.dismiss()
                    fail(error as NSError)
                }
        }
    }
    
//    class func multiPart<T: AnyObject>(params: Dictionary<String, AnyObject>, serviceName: String,imageParam: String ,videoParam: String , serviceType: String,videoPath:String?, thumbPath :String?,modelType: T.Type, success: @escaping ( _ servicResponse: AnyObject) -> Void, fail: @escaping (_ error: NSError) -> Void) where T: Mappable {
//        print(params.description)
//        
//        let manager = Alamofire.SessionManager.default
//        manager.session.configuration.timeoutIntervalForRequest = 120
//        
//        showNetworkIndicator()
//        
//        Alamofire.upload(
//            multipartFormData: { MultipartFormData in
//                
//                for (key, value) in params {
//                    MultipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                }
//
////                let data =  FileManager.default.contents(atPath:TQSharedHelper.getFileURL(path:videoPath!))
////                let thumbData = FileManager.default.contents(atPath:TQSharedHelper.getFileURL(path:thumbPath!))
//                
//                //let videoData = NSData(contentsOfFile: videoPathUrl)
//                MultipartFormData.append(data!, withName: videoParam, fileName:"upload_video.mp4", mimeType:"video/mp4")
//                MultipartFormData.append(thumbData!, withName: imageParam, fileName:"image.jpeg", mimeType:"image/png")
//               
//        },
//            to: serviceName) { (result ) in
//                switch result {
//                case .success(let upload, _, _):
//                    upload.responseJSON { response in
//                        print(response.result.value as Any)
//                        if(response.result.value != nil){
//                        let convertedResponse = Mapper<T>().map(JSON:response.result.value as! [String : Any])
//                        //let convertedResponse3 = Mapper<UploadedPostObject>().map
//                            hideNetworkIndicator()
//                            success(convertedResponse as AnyObject)
//                        }else{
//                            hideNetworkIndicator()
//                            success("no internet" as AnyObject)
//                        }
//                    }
//                    
//                case .failure(let encodingError):
//                    print(encodingError)
//                    hideNetworkIndicator()
//                    fail(encodingError as NSError)
//                }
//        }
//    }
    
//    class func multiPartImage<T: AnyObject>(params: Dictionary<String, AnyObject>, serviceName: String,imageParam: String , serviceType: String,profileImage:UIImage? , cover_image_param: String, cover_image: UIImage?,modelType: T.Type, success: @escaping ( _ servicResponse: AnyObject) -> Void, fail: @escaping (_ error: NSError) -> Void) where T: Mappable {
//
//        SVProgressHUD.show()
//        progressHudSetting()
//        showNetworkIndicator()
//
//        Alamofire.upload(multipartFormData:{ multipartFormData in
//            if profileImage != nil {
//                if let imageData = UIImageJPEGRepresentation(profileImage!, 0.5) {
//                    multipartFormData.append(imageData, withName:imageParam, fileName:"files.png", mimeType: "image/png")
//                }
//            }
//                // import parameters
//            for (key, value) in params {
//                let val = value as! String
//                multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
//            }
//        },
//            to: serviceName,
//            encodingCompletion: { encodingResult in
//
//                hideNetworkIndicator()
//
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON { response in
//                        print(response.result.value as Any)
//                        SVProgressHUD.dismiss()
//                        if(response.result.value != nil){
////                            let convertedResponse = Mapper<Audition>().map(JSON:response.result.value as! [String : Any])
////                            /let convertedResponse3 = Mapper<UploadedPostObject>().map
////                            success(convertedResponse as AnyObject)
//                        }else{
//                            success("no internet" as AnyObject)
//                        }
//                    }
//                case .failure(let encodingError):
//                    print(encodingError)
//                    SVProgressHUD.dismiss()
//                    fail(encodingError as NSError)
//                }
//
//            }
//        )
//    }
    
    
    class func multiPartImageWithOutHeader<T: AnyObject>(params: Dictionary<String, Any>, serviceName: String,imageParam: String , imgFileName:String , serviceType: String,profileImage:UIImage? , cover_image_param: String, cover_image: UIImage?,modelType: T.Type, success: @escaping ( _ servicResponse: Any) -> Void, fail: @escaping (_ error: NSError) -> Void) where T: Mappable {
        
        //        SVProgressHUD.show()
        showNetworkIndicator()
        Alamofire.upload(multipartFormData:{ multipartFormData in
            if profileImage != nil {
                
                if let imageData = profileImage?.jpegData(compressionQuality: 0.5) {
                    multipartFormData.append(imageData, withName:imageParam, fileName:imgFileName, mimeType: "image/png")
                }
            }
            for (key, value) in params {
                let val = value as! String
                multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
            }
        },
                         to: serviceName,
                         encodingCompletion: { encodingResult in
                            
                            hideNetworkIndicator()
                            
                            switch encodingResult {
            
                            case.success(let objectData):
                           
                                SVProgressHUD.dismiss()
                                success(objectData)
                            case.failure(let error):
                                print(error.localizedDescription)
                                SVProgressHUD.dismiss()
                                fail(error as NSError)
                            }
                            
        }
        )
    }
    
    //multipartFormData.appendBodyPart(fileURL: videoPathUrl!, name: "video")
    class func uploadVideoOnServer(parameters: Dictionary<String, AnyObject>,videoPathUrl : URL, serviceName: String, showHUD: Bool,success: @escaping ( _ servicResponse: AnyObject) -> Void, fail: (_ error: NSError) -> Void) {
        
        
        if showHUD {
            SVProgressHUD.show()
            progressHudSetting()
        }
        
        showNetworkIndicator()
        
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
                
                for (key, value) in parameters {
                    MultipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                // Get the Document directory path
                let documentDirectorPath:String = paths[0]
                // Create a new path for the new images folder
                var aString   = "March 21 2017 06:28:03pm"
                aString.append(".mp4")
                let dataPath =  "\(documentDirectorPath)/\(aString)"
                let data = FileManager.default.contents(atPath: dataPath)
                
                //let videoData = NSData(contentsOfFile: videoPathUrl)
                MultipartFormData.append(data!, withName: "data[Post][file][0]", fileName:"upload_video.mp4", mimeType:"video/mp4")
             
        }, to: serviceName) { (result) in
            
            hideNetworkIndicator()
            
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    print(response.result.value as Any)
                    success(response as AnyObject)
                }
                
            case .failure(let encodingError):
                if showHUD {
                    SVProgressHUD.dismiss()
                }
                print(encodingError)
            }
        }
    }
    
    class func multiPartImageMorePhotos<T: AnyObject>(params: Dictionary<String, AnyObject>,morePhotos: [UIImage]?, serviceName: String,imageParam: String , serviceType: String,profileImage:UIImage? , cover_image_param: String, cover_image: UIImage?,modelType: T.Type, success: @escaping ( _ servicResponse: AnyObject) -> Void, fail: @escaping (_ error: NSError) -> Void) where T: Mappable {
        
        SVProgressHUD.show()
        progressHudSetting()
        showNetworkIndicator()
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                if morePhotos != nil && (morePhotos?.count)! > 0 {
                    for (index, obj) in (morePhotos?.enumerated())! {
//                        multipartFormData.append(SharedHelper.compressImageWithAspectRatio(image: obj), withName: "file[\(index)]", fileName: "file\(index).png", mimeType: "image/png")
                    }
                }
                
                // import parameters
                for (key, value) in params {
                    let val = value as! String
                    multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
                }
        },
            to: serviceName,
            encodingCompletion: { encodingResult in
                
                hideNetworkIndicator()
                
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        print(response.result.value as Any)
                        SVProgressHUD.dismiss()
                        if(response.result.value != nil){
//                            let convertedResponse = Mapper<Audition>().map(JSON:response.result.value as! [String : Any])
//                            ///let convertedResponse3 = Mapper<UploadedPostObject>().map
//                            success(convertedResponse as AnyObject)
                        }else{
                            let error = NSError()
                            fail(error)
                        }
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                    SVProgressHUD.dismiss()
                    fail(encodingError as NSError)
                }
        }
        )
    }

  
    
    class func showNetworkIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            WebServiceManager.serviceCount += 1
        }
    }
    
    class func hideNetworkIndicator() {
        WebServiceManager.serviceCount -= 1
        if WebServiceManager.serviceCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    class func setBorderAndCornerRadius(layer: CALayer, width: CGFloat, radius: CGFloat,color : UIColor ) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }

}

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}


