//
//  PKCountryPicker.swift
//
//  Created by Pramod Kumar on 07/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

open class PKCountryPicker: UIView {
    
    enum Appearance {
        case dark
        case light
    }
    
    //MARK:- Properties
    //MARK:- Public
    public static let `default` = PKCountryPicker(frame: CGRect.zero)
    var countries: [PKCountryModel] = [PKCountryModel]()
    
    //MARK:- Private
    private let pickerView: UIPickerView = UIPickerView()
    private var selectionHandler: ((PKCountryModel, Bool)->Void)?
    private weak var parantVC: UIViewController? = nil
    private var currentSelectedIndex: Int = 0
    private var preSelectedCountry: PKCountryModel?
    let selection = UISelectionFeedbackGenerator()
    private var isSelectionChanged: Bool = false
    
    //MARK:- Picker Life Cycle
    //MARK:-
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Please user default instance. (PKCountryPicker.default.chooseCountry())")
    }
    
    //MARK:- Methods
    //MARK:- Public
    public func chooseCountry(onViewController: UIViewController, preSelectedCountry: PKCountryModel? = nil, selectionHandler: @escaping ((PKCountryModel, Bool)->Void)) {
        self.initialSetup()
        self.selectionHandler = selectionHandler
        self.parantVC = onViewController
        self.preSelectedCountry = preSelectedCountry
        self.openPicker()
    }
    
    
    public func getCountryData(forISDCode: String) -> PKCountryModel? {
        let allCountries = self.countries//self.getAllCountries()
        
        var finalISD = forISDCode
        
        if PKCountryPickerSettings.shouldAddPlusInCountryCode, !finalISD.hasPrefix("+") {
            finalISD = "+\(finalISD)"
        }
        else if !PKCountryPickerSettings.shouldAddPlusInCountryCode, finalISD.hasPrefix("+") {
            finalISD.removeFirst()
        }
        
        return allCountries.filter { (country) -> Bool in
            country.countryCode == finalISD
            }.first
    }
    
    public func getCurrentLocalCountryData() -> PKCountryModel? {
        if let countryData = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            return self.getCountryData(forISOCode: countryData)
        }
        return nil
    }
    
    public func getCountryData(forISOCode: String) -> PKCountryModel? {
        let allCountries = self.countries//self.getAllCountries()self.getAllCountries()
        
        return allCountries.filter { (country) -> Bool in
            country.ISOCode.lowercased() == forISOCode.lowercased() || country.countryEnglishName.lowercased() == forISOCode.lowercased()
            }.first
    }
    
    //MARK:- Private
    private func initialSetup() {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIPickerView.pickerSize.width, height: UIPickerView.pickerSize.height)
        
        self.pickerView.frame = CGRect(x: 0.0, y: 0, width: UIPickerView.pickerSize.width, height: UIPickerView.pickerSize.height)
        self.addSubview(self.pickerView)
        self.countries = self.getAllCountries()
        self.setupToolBar()
        self.setupAppearance()
        self.pickerView.selectRow(0, inComponent: 0, animated: false)
    }
    
    private func setupToolBar() {
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0.0, y: -10, width: PKCountryPickerSettings.pickerSize.width, height: PKCountryPickerSettings.toolbarHeight)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(pickerCancelButtonTapped))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(pickerDoneButtonTapped))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action:nil)
        // Adding top divider in country Picker
//        let topBorder = CALayer()
//        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: PKCountryPickerSettings.pickerSize.width, height: 0.5)
//        topBorder.backgroundColor = AppColors.themeGray20.cgColor
//        toolbar.layer.addSublayer(topBorder)
//
        
        if PKCountryPickerSettings.appearance == .dark {
            //toolbar.barTintColor = UIColor(displayP3Red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
            toolbar.backgroundColor = .clear
            toolbar.barTintColor = AppColors.secondarySystemFillColor
            cancelButton.tintColor = UIColor(displayP3Red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
            doneButton.tintColor = UIColor(displayP3Red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        }
        else {
//            toolbar.backgroundColor = AppColors.themeGray40
//            toolbar.barTintColor = UIColor(displayP3Red: 0.9921568627, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
            toolbar.backgroundColor = .clear
            toolbar.barTintColor = AppColors.secondarySystemFillColor
            cancelButton.tintColor = AppColors.themeGreen
            doneButton.tintColor = AppColors.themeGreen
        }
        
        // nitin removed the cancel button
        let array = [ spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        self.backgroundColor = AppColors.quaternarySystemFillColor
        // nitin change
        //self.addBlurEffect(backgroundColor: AppColors.quaternarySystemFillColor, style: .dark, alpha: 1.0)
        toolbar.clipsToBounds = true
        self.addSubview(toolbar)
    }
    
    private func setupAppearance() {
        // nitin change
        //        if PKCountryPickerSettings.appearance == .dark {
        //            self.pickerView.backgroundColor = UIColor(displayP3Red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        //            self.pickerView.setValue(UIColor(displayP3Red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1), forKey: "textColor")
        //        }
        //        else {
        //self.pickerView.backgroundColor = UIColor(displayP3Red: 0.9921568627, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
        self.pickerView.setValue(UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1), forKey: "textColor")
        //        }
    }
    
     func getAllCountries() -> [PKCountryModel] {
        var countries = [PKCountryModel]()
        let frameworkBundle = Bundle(for: PKCountryPicker.self)
        guard let jsonPath = frameworkBundle.path(forResource: "countryData", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
            return countries
        }
        
        do {
            if let jsonObjects = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String:Any]] {
                countries = PKCountryModel.getModels(jsonArr: jsonObjects)
            }
        }
            
        catch {
            return countries
        }
//        let sortedCountries = countries.sort(by: {$0.countryEnglishName < $1.countryEnglishName})
        countries.sort(by: {$0.countryEnglishName < $1.countryEnglishName})
        return countries
    }
    
    private func openPicker(animated: Bool = true) {
        guard let parent = self.parantVC else {return}
        self.pickerView.reloadAllComponents()
        parent.view.endEditing(true)
        parent.view.addSubview(self)
        
        let visibleFrame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - UIPickerView.pickerSize.height, width: UIPickerView.pickerSize.width, height: UIPickerView.pickerSize.height)
        
        if let pre = self.preSelectedCountry, let index = self.countries.firstIndex(where: {$0.ISOCode.lowercased() == pre.ISOCode.lowercased()}){
            self.currentSelectedIndex = index
            self.pickerView.selectRow(index, inComponent: 0, animated: false)
        }
        
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.frame = visibleFrame
        }) { (isCompleted) in
//            if let pre = self.preSelectedCountry {
//                self.pickerView.selectRow(pre.sortIndex-1, inComponent: 0, animated: false)
//            }
        }
    }
    
    func closePicker(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        
        let hiddenFrame = CGRect(x: (UIScreen.main.bounds.size.width-PKCountryPickerSettings.pickerSize.width)/2.0, y: UIScreen.main.bounds.size.height, width: PKCountryPickerSettings.pickerSize.width, height: (PKCountryPickerSettings.pickerSize.height + PKCountryPickerSettings.toolbarHeight))
        
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.frame = hiddenFrame
        }) { (isCompleted) in
            self.removeFromSuperview()
            completion?(isCompleted)
        }
    }
    
    //MARK:- Action
    @IBAction private func pickerCancelButtonTapped(){
        self.closePicker()
    }
    
    @IBAction private func pickerDoneButtonTapped(){
        
        if let handler = self.selectionHandler {
            // if picker selection changed sent that country, else sent previous selected coutry, Default value for previous
            isSelectionChanged ?  handler(self.countries[self.currentSelectedIndex], true) : handler(preSelectedCountry ?? self.getCountryData(forISDCode: "+91")!, true)
        }
        self.closePicker()
    }
}

//MARK:- Picker Delegate and Datasource methods
//MARK:-
extension PKCountryPicker: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.countries.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return PKCountryPickerSettings.rowHeight
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let contentView = PKCountryView.instanceFromNib
        contentView.frame = CGRect(x: 0.0, y: 0.0, width: PKCountryPickerSettings.pickerSize.width, height: PKCountryPickerSettings.rowHeight)
        contentView.countryData = self.countries[row]
        contentView.backgroundColor = UIColor.clear
        return contentView
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentSelectedIndex = row
        self.isSelectionChanged = true
        selection.selectionChanged()
        
        //  Commented because ,Requirement was not to update country when selection changed
        // nitin change
        if let handler = self.selectionHandler {
            handler(self.countries[self.currentSelectedIndex], false)
            
        }
    }
}
