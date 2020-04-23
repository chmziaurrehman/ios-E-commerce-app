//
//  QImageSlider.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 13/09/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire

class QImageSlider: UIView {
    @IBOutlet weak var sliderView: ImageSlideshow!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
        func setSliderImages(banners: [BannerImage])  {
            var sorces = [AlamofireSource]()
            for  i in 0..<banners.count {
                if let url = banners[i].image {
                    sorces.append(AlamofireSource(urlString: url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!)
                }
            }
            DispatchQueue.main.async {
                self.sliderView.slideshowInterval = 4.0
                self.sliderView.contentMode = .scaleToFill
                self.sliderView.contentScaleMode = .scaleAspectFill
                self.sliderView.setImageInputs(sorces)
            }
        }

}
