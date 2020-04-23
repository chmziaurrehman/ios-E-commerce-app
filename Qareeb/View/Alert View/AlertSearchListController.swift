//
//  AlertSearchListController.swift
//  PatientApp
//
//  Created by Usman Javed on 12/9/16.
//  Copyright © 2016 Usman Javed. All rights reserved.
//

import UIKit

class AlertSearchListController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    //MARK:- Data Members
    var calbacks : getValues?
    var dataSource : [ListItem] = []
    var searchResult : [ListItem] = []
    var isPopoverDismissed : Bool = false
    var searchActive : Bool = false

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    
    //MARK:- Life Cycle
    
    init(dataSource : [ListItem])
    {
        super.init(nibName: nil, bundle: nil)
        self.dataSource = dataSource
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        tableview.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    //MARK:- Private Helping Methods
    func filterContentForSearchText(searchText: String) {
        
        self.searchResult = self.dataSource.filter({( aSpecies: ListItem) -> Bool in
            return (((aSpecies[aSpecies.value!] as! String).lowercased().range(of: searchText.lowercased())) != nil)
        })
        if(searchResult.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        tableview.reloadData()
    }
    
    //MARK:- Search Bar Delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchActive = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterContentForSearchText(searchText: searchText)
    }
    
    // MARK: - Table Veiw Datasource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive {
            
            return searchResult.count
        }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cellMultiSelection"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if (cell == nil) {
            
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        var item : ListItem = dataSource[indexPath.row]
        if searchActive {
            
            item = searchResult[indexPath.row]
        }
        
//        cell!.accessoryType = (item.isSelected ? .checkmark : .none)
        cell?.textLabel?.text = (item[item.value!] as! String)
        cell?.textLabel?.font = UIFont(name: "Montserrat-Regular", size: 17.0)
        cell?.backgroundColor = UIColor.clear
        cell?.contentView.backgroundColor = UIColor.clear
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searchActive {
            
            calbacks!(searchResult[indexPath.row])
            searchResult[indexPath.row].isSelected = !searchResult[indexPath.row].isSelected
            
        } else {
            
            calbacks!(dataSource[indexPath.row])
            dataSource[indexPath.row].isSelected = !dataSource[indexPath.row].isSelected
        }
        
        dismissAlertController()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: - Show Popover Controller
    func showPopOverController(parentController : UIViewController, sourceRect: CGRect, sourceView : UIView,completion: @escaping getValues) -> Void {
        
        self.modalPresentationStyle = .popover
        _ = self.popoverPresentationController
        if let popover = self.popoverPresentationController {
            
            popover.delegate = self
            popover.sourceView = sourceView
            popover.sourceRect = sourceRect
            self.preferredContentSize = CGSize(width: 375, height: 350)
        }
        parentController.present(self, animated: true, completion:{() in
        })
        
        calbacks = completion
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController){
        
        isPopoverDismissed = true
    }
    
    func dismissAlertController () {
        
        isPopoverDismissed = true
        dismiss(animated: true, completion: nil)
    }
}
