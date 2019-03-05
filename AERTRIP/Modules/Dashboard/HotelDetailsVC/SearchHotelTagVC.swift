//
//  SearchHotelTagVC.swift
//  
//
//  Created by Admin on 04/03/19.
//

import UIKit

protocol AddTagButtonDelegate: class {
    func addTagButtons(tagName: String)
}

class SearchHotelTagVC: BaseVC {
    
    //Mark:- Variables
    //================
    internal var tagButtons: [String] = []
    internal var copyOfTagButtons: [String] = []
    internal weak var delegate: AddTagButtonDelegate?
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var tagTableView: UITableView! {
        didSet {
            self.tagTableView.delegate = self
            self.tagTableView.dataSource = self
            self.tagTableView.estimatedRowHeight = 44.0
            self.tagTableView.rowHeight = 44.0
        }
    }
    @IBOutlet weak var searchBar: ATSearchBar!
    @IBOutlet weak var cancelBtnOutlet: UIButton!
    @IBOutlet weak var dividerView: ATDividerView! {
        didSet {
            self.dividerView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.5)
        }
    }
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupTexts() {
        self.cancelBtnOutlet.setTitle(LocalizedString.Cancel.localized, for: .normal)
    }
    
    override func setupFonts() {
        self.cancelBtnOutlet.titleLabel?.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupColors() {
        self.cancelBtnOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
    }
    
    override func initialSetup() {
        self.copyOfTagButtons = self.tagButtons
    }
    
    override func bindViewModel() {
        self.searchBar.delegate = self
    }
    
    //Mark:- Functions
    //================
    ///UPDATE DATA SOURCE FOR FILTER
    ///Update Data Source
    private func updateDataSource(queryStr: String) {
        self.copyOfTagButtons = self.tagButtons.filter({ (currentTag) -> Bool in
            let tempStr: NSString = currentTag as NSString
            let range = tempStr.range(of: queryStr, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
    }
    
    //Mark:- IBActions
    //================
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//Mark:- UITableView Delegate And DataSource
//==========================================
extension SearchHotelTagVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.copyOfTagButtons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTagTableCell", for: indexPath) as? SearchTagTableCell else { return UITableViewCell() }
        cell.hotelTagName.text = self.copyOfTagButtons[indexPath.row]
        if indexPath.row == self.copyOfTagButtons.count - 1 {
            cell.dividerViewLeadingConstraints.constant = 0.0
        } else {
            cell.dividerViewLeadingConstraints.constant = 16.0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        printDebug(self.copyOfTagButtons[indexPath.row])
        if let safeDelegate = self.delegate {
            safeDelegate.addTagButtons(tagName: self.copyOfTagButtons[indexPath.row])
        }
        self.dismiss(animated: true, completion: nil)
    }
}

//Mark:- UISearch Bar Delegate
//============================
extension SearchHotelTagVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        printDebug(searchText)
        if searchText == "" {
            self.copyOfTagButtons = self.tagButtons
        } else {
            self.updateDataSource(queryStr: searchText)
        }
        self.tagTableView.reloadData()
    }
}
