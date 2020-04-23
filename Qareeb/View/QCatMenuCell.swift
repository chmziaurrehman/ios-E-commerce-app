//
//  QCatMenuCell.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 19/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QCatMenuCell: UICollectionViewCell {

    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var isSelectedView: UIViewX!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override var isSelected: Bool {
        get {  return super.isSelected; }
        set {
            if (super.isSelected != newValue) {
                super.isSelected = newValue
                if (newValue == true) {
                    self.isSelectedView.backgroundColor = UIColor(named: "blueberry")
                } else {
                    self.isSelectedView.backgroundColor = .white
                    
                }
            }
        }
    }
   
}
