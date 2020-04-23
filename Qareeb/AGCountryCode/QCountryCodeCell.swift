//
//  QCountryCodeCell.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 10/07/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QCountryCodeCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var countryImage:        UIImageView!
    @IBOutlet weak var countryTitle:        UILabel!
    @IBOutlet weak var countryCode:         UILabel!
    let animatedView = UIView()
    var closeView:(()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if isSelected {
            rippleAffect()
        }
        self.backgroundColor = selected ?  #colorLiteral(red: 0.9731286873, green: 0.9731286873, blue: 0.9731286873, alpha: 0.8548448351) : UIColor.clear
        // Configure the view for the selected state
    }
    
//    func rip() {
//        self.layoutIfNeeded()
//        UIView.animate(withDuration: 0.2, animations: {
//            self.outerView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
//        }) { (true) in
//            self.outerView.transform = CGAffineTransform(scaleX: -1, y: -1)
//            self.layoutIfNeeded()
//        }
//        self.layoutIfNeeded()
//    }
    func rippleAffect() {
        let view = UIViewX(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        view.center = self.contentView.center
        self.contentView.addSubview(view)
        
        UIViewX.animate(withDuration: 0.4, animations: {
            view.transform = CGAffineTransform(scaleX: 500, y: 500)
            view.alpha = 0
        }) { (true) in
            self.closeView?()
            view.removeFromSuperview()
        }
    }
    
    //MARK: - Public methods
    
    func setupCell(country: Country) {
        countryTitle.text = country.name
        countryCode.text = country.dial_code
        countryImage.image = country.flag
    }
    
}
