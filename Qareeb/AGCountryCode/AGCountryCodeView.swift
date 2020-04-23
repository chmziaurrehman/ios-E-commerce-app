//
//  AGCountryCodeView.swift
//  demo
//
//  Created by Antonio González Hidalgo on 16/01/2019.
//  Copyright © 2019 Antonio Gonzalez Hidalgo. All rights reserved.
//

import UIKit

internal class Country:Decodable {
    
    var name:String?
    var dial_code:String?
    var code:String?
    var flag: UIImage? {
        guard let _code = code else {
            return nil
        }
        return UIImage(named: _code.lowercased(), in: Bundle(for: AGCountryCodeView.self), compatibleWith: nil)
    }
}

public protocol AGCountryCodeViewDelegate {
    
    /// Every time the user selects a country, the delegate will call this function.
    ///
    /// - Parameters:
    ///   - view: Sender (AGCountryCodeView)
    ///   - countryName: The name of the country selected
    ///   - countryCode: The code of the country selected
    ///   - countryDialCode: The dial code of the country selected
    ///   - flag: The flag of the country selected
    func countryPickerSelectedCountry(view: AGCountryCodeView,
                                      countryName:String?,
                                      countryCode:String?,
                                      countryDialCode:String?,
                                      flag:UIImage?)
}

public class AGCountryCodeView: UIView {
    
    //MARK: - Constants

    let cellHeight:CGFloat =            40.0

    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var contentView:          UIView!
    @IBOutlet var searchFieldTxt:       UITextField!
    
    //MARK: - Private variables
    
    private var fullCountries:          [Country]!
    private var countries:              [Country]!
    private var selectedCountry:        Country? = nil
    
    //MARK: - Public variables
    
    public var delegate:AGCountryCodeViewDelegate?
    
    
    //MARK: - Inits
    
    public init(){
        super.init(frame: UIScreen.main.bounds)
        setupCountryCodeView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupCountryCodeView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCountryCodeView()
    }
    
    deinit {
//        unregisterKeyboardNotifications()
    }

    //MARK: - Private methods
    
    private func setupCountryCodeView(){
        
        loadCountries()
//        registerKeyboardNotifications()
        if let contentView = loadViewFromNib() {
            addSubview(contentView)
            self.tableView.register(UINib(nibName: "QCountryCodeCell", bundle: nil), forCellReuseIdentifier: "QCountryCodeCell")
            searchFieldTxt.delegate = self
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
//            pickerContentView.layer.cornerRadius = 5.0
//            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeCountryPicker)))
        }
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AGCountryCodeView", bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return view
        }
        return nil
    }
    

    
    //MARK: - Load data
    
    private func loadCountries() {
        fullCountries = countryNamesByCode()
        countries = countryNamesByCode()
    
    }
    
    private func countryNamesByCode() -> [Country] {  
        
        var countries = [Country]()
        let frameworkBundle = Bundle(for: AGCountryCodeView.self)
        
        guard let jsonPath = frameworkBundle.path(forResource: "Countries", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
            return countries
        }
        
        do {
            countries = try JSONDecoder().decode([Country].self, from: jsonData)
        } catch {
            print("Error parsing the countries json")
        }
        return countries
    }
    
    private func selectedCountry(countryCode:String?) -> [Country] {
        guard let country = countryCode else { return fullCountries }
        countries = fullCountries.filter { $0.name!.uppercased().contains(country.uppercased()) }
        return countries.count == 0 ? fullCountries : countries
    }
    
    //MARK: - Actions

    @objc private func closeCountryPicker(){
        removeFromSuperview()
    }
    
    @IBAction func btnDismiss(_ sender: Any) {
        closeCountryPicker()
    }
}


// MARK: - UIPickerViewDataSource
extension AGCountryCodeView: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QCountryCodeCell", for: indexPath) as! QCountryCodeCell
        cell.setupCell(country: countries[indexPath.row])
        cell.selectionStyle = .none
        cell.closeView = {() -> Void in
            self.closeCountryPicker()
        }
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCountry = countries[indexPath.row]
        delegate?.countryPickerSelectedCountry(view: self,
                                               countryName: selectedCountry?.name,
                                               countryCode: selectedCountry?.code,
                                               countryDialCode: selectedCountry?.dial_code,
                                               flag: selectedCountry?.flag)
    }
}

// MARK: - UITextFieldDelegate
extension AGCountryCodeView: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var str:String = textField.text!
        str = string == "" ? String(str.dropLast()) : str + string
        countries = selectedCountry(countryCode: str)
        tableView.reloadData()
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
//        hideKeyboard()
        searchFieldTxt.resignFirstResponder()
    
        return true;
    }
    
}
