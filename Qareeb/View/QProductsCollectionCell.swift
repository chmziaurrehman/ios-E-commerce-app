//
//  QProductsCollectionCell.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 20/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QProductsCollectionCell: UITableViewCell , UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblname: UILabel!
    
    @IBOutlet weak var btnViewMore: UIButton!
    @IBOutlet weak var imgArrow: UIImageView!

    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var viewMore:(()-> Void)!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        localizeStrings()
    }

    //Localization configrations
    func localizeStrings() {
//        LocalizationSystem.shared.setLanguage(languageCode: language)
        btnViewMore.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "view_more", comment: ""), for: .normal)
//        let flippedImage = UIImage(named: "back")?.imageFlippedForRightToLeftLayoutDirection()
//        imgArrow.image = flippedImage
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColor = selected ? UIColor.clear : UIColor.clear
        
        // Configure the view for the selected state
    }
    @IBAction func btnViewMore(_ sender: Any) {
        self.viewMore()
    }
    
}





extension QProductsCollectionCell{
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDelegate & UICollectionViewDataSource>
        (_ dataSourceDelegate: D, forRow row:Int){
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        
    }
}
