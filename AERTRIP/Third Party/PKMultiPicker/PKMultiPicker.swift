//
//  PKMultiPicker.swift
//
//  Created by Pramod Kumar on 28/10/16.
//  Copyright © 2015 Pramod Kumar. All rights reserved.
//

import UIKit

class PKMultiPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    internal typealias PickerDone = (_ firstValue: String, _ secondValue: String) -> Void
    
    internal typealias PickerDoneWithIndex = (_ firstValue: Int?, _ secondValue: Int?) -> Void

    
    private var doneBlock : PickerDone?
    
    private var doneBlockWithIndex : PickerDoneWithIndex?

    
    private var firstValueArray : [String]?
    private var secondValueArray = [String]()
    static var noOfComponent = 2
    
    deinit {
        printDebug("deinit PKMultiPicker")
        doneBlock = nil
        self.removeFromSuperview()
    }
    
    class func openMultiPickerIn(_ textField: UITextField? , firstComponentArray: [String], secondComponentArray: [String], firstComponent: String?, secondComponent: String?, titles: [String]?, toolBarTint: UIColor = UIColor.black, doneBlock: @escaping PickerDone, doneWithIndex : PickerDoneWithIndex? = nil) {
        
        let picker = PKMultiPicker()
        picker.doneBlock = doneBlock
        picker.doneBlockWithIndex = doneWithIndex
        picker.openPickerInTextField(textField, firstComponentArray: firstComponentArray, secondComponentArray: secondComponentArray, firstComponent: firstComponent, secondComponent: secondComponent, toolBarTint: toolBarTint)
        
        if titles != nil {
            let label = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width/4 - 10, y: 0, width: 100, height: 30))
            label.text = titles![0].uppercased()
            label.font = UIFont.boldSystemFont(ofSize: 18)
            picker.addSubview(label)
            
            if PKMultiPicker.noOfComponent > 1 {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
                label.text = titles![1].uppercased()
                label.font = UIFont.boldSystemFont(ofSize: 18)
                picker.addSubview(label)
            } else {
                label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 30)
                label.textAlignment = NSTextAlignment.center
            }
        }
    }
    
    private func openPickerInTextField(_ textField: UITextField?, firstComponentArray: [String], secondComponentArray: [String], firstComponent: String?, secondComponent: String?, toolBarTint: UIColor = UIColor.black) {
        
        firstValueArray  = firstComponentArray
        secondValueArray = secondComponentArray
        
        self.delegate = self
        self.dataSource = self
        
     
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(pickerCancelButtonTapped))
//        cancelButton.tintColor = toolBarTint
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(pickerDoneButtonTapped))
        doneButton.tintColor = toolBarTint
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action:nil)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let array = [ spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        
        toolbar.backgroundColor = .clear
        toolbar.barTintColor = AppColors.secondarySystemFillColor
        
        let genericPickerView: UIView = UIView()
        let pickerSize: CGSize = UIPickerView.pickerSize
        self.frame = CGRect(x: 0, y: 0, width: pickerSize.width, height: pickerSize.height)
        genericPickerView.addSubview(self)
        genericPickerView.frame = CGRect(x: 0, y: 0, width: pickerSize.width, height: pickerSize.height)
        genericPickerView.backgroundColor = AppColors.quaternarySystemFillColor
        //genericPickerView.addBlurEffect(backgroundColor: AppColors.quaternarySystemFillColor, style: .dark, alpha: 1.0)
        
        
        textField?.inputView = genericPickerView
        textField?.inputAccessoryView = toolbar
        
        
        let index = self.firstValueArray?.firstIndex(where: {$0.lowercased() == (firstComponent ?? "").lowercased() })
        self.selectRow(index ?? 0, inComponent: 0, animated: true)

        
        if PKMultiPicker.noOfComponent > 1 {
            let index1 = self.secondValueArray.firstIndex(where: {$0.lowercased() == (secondComponent ?? "").lowercased() })
            self.selectRow(index1 ?? 0, inComponent: 1, animated: true)
        }
    }
   
    @IBAction private func pickerCancelButtonTapped(){
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    @IBAction private func pickerDoneButtonTapped(){
        
        UIApplication.shared.keyWindow?.endEditing(true)
        
        valueChanged()
    }
    
    private func valueChanged() {
        let index1 : Int?
        let firstValue : String?
        index1 = self.selectedRow(inComponent: 0)
        
        if firstValueArray?.count == 0{return}
        else{firstValue = firstValueArray?[index1!]}
        
        var index2 :Int!
        var secondValue: String!
        if PKMultiPicker.noOfComponent > 1 {
            index2 = self.selectedRow(inComponent: 1)
            secondValue = secondValueArray[index2]
        }
        
        self.doneBlockWithIndex?(index1,index2)
        self.doneBlock?((firstValue ?? ""), (secondValue ?? ""))
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if component == 0 {
            return firstValueArray!.count
        }
        return secondValueArray.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return PKMultiPicker.noOfComponent
    }

    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
            
        case 0:
            return firstValueArray?[row]
        case 1:
            return secondValueArray[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        valueChanged()
    }
}

enum DatePickerError{
    case maxExceed
    case minExceed
}

class PKDatePicker: UIDatePicker {
    
    enum Appearance {
        case dark
        case light
    }
    
    internal typealias PickerDone = (_ selection: String) -> Void
    private var doneBlock: PickerDone?
    private var datePickerFormat: String = ""
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.datePickerFormat
        let enUSPOSIXLocale: Locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPOSIXLocale
        
        return dateFormatter
    }
    
    //Picker with error in case of flight passenger details.
    internal typealias PickerDoneWithError = (_ selection: String, _ isError:Bool, _ errorType:DatePickerError?) -> Void
    private var doneBlockWithError: PickerDoneWithError?
    private var minDate:Date?
    private var maxDate:Date?
    private var isErroType:Bool = false
    
    
    deinit {
        printDebug("deinit PKDatePicker")
        doneBlock = nil
        self.removeFromSuperview()
    }
    
    class func openDatePickerIn(_ textField: UITextField?, outPutFormate: String, mode: UIDatePicker.Mode, minimumDate: Date? = nil, maximumDate: Date? = nil, minuteInterval: Int = 1, selectedDate: Date?, appearance: Appearance = .light, toolBarTint: UIColor? = nil, doneBlock: @escaping PickerDone) {
        
        let picker = PKDatePicker()
        picker.doneBlock = doneBlock
        picker.datePickerFormat = outPutFormate
        picker.datePickerMode = mode
        picker.dateFormatter.dateFormat = outPutFormate
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }

        if let sDate = selectedDate {
            picker.setDate(sDate, animated: false)
        }
        picker.minuteInterval = minuteInterval
        
        if let minDate = minimumDate, mode == .time {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            let today = dateFormatter.string(from: Date())
            let minDay = dateFormatter.string(from: minDate)
            
            picker.minimumDate = today.lowercased() == minDay.lowercased() ? Date() : minDate
        }
        else {
            picker.minimumDate = minimumDate
        }
        
        picker.maximumDate = maximumDate
        
        picker.openDatePickerInTextField(textField, appearance: appearance, toolBarTint: toolBarTint)
    }
    
    class func openDatePickerWithError(_ textField: UITextField?, outPutFormate: String, mode: UIDatePicker.Mode, minimumDate: Date? = nil, maximumDate: Date? = nil, minuteInterval: Int = 1, selectedDate: Date?, appearance: Appearance = .light, toolBarTint: UIColor? = nil, doneBlock: @escaping PickerDoneWithError) {
        
        let picker = PKDatePicker()
        picker.doneBlockWithError = doneBlock
        picker.datePickerFormat = outPutFormate
        picker.datePickerMode = mode
        picker.isErroType = true
        picker.dateFormatter.dateFormat = outPutFormate
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }

        if let sDate = selectedDate {
            picker.setDate(sDate, animated: false)
        }
        picker.minuteInterval = minuteInterval
        
        if let minDate = minimumDate, mode == .time {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            let today = dateFormatter.string(from: Date())
            let minDay = dateFormatter.string(from: minDate)
            picker.minDate = today.lowercased() == minDay.lowercased() ? Date() : minDate
//            picker.minimumDate = today.lowercased() == minDay.lowercased() ? Date() : minDate
        }
        else {
            picker.minDate = minimumDate
//            picker.minimumDate = minimumDate
        }
        
//        picker.maximumDate = maximumDate
        picker.maxDate = maximumDate
        
        picker.openDatePickerInTextField(textField, appearance: appearance, toolBarTint: toolBarTint)
    }
    
    private func openDatePickerInTextField(_ textField: UITextField?, appearance: Appearance = .light, toolBarTint: UIColor? = nil) {

        if let text = textField?.text, !text.isEmpty, let selDate = self.dateFormatter.date(from: text) {
            self.setDate(selDate, animated: false)
        }
        
        self.addTarget(self, action: #selector(PKDatePicker.datePickerChanged(_:)), for: UIControl.Event.valueChanged)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(pickerCancelButtonTapped))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(pickerDoneButtonTapped))
        doneButton.tintColor = toolBarTint
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action:nil)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
//        if appearance == .dark {
//            self.backgroundColor = UIColor(displayP3Red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
//            self.setValue(UIColor(displayP3Red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1), forKey: "textColor")
//            toolbar.barTintColor = UIColor(displayP3Red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
//            cancelButton.tintColor = toolBarTint ?? UIColor(displayP3Red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
//            doneButton.tintColor = toolBarTint ?? UIColor(displayP3Red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
//        }
//        else {
//            self.backgroundColor = UIColor(displayP3Red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
            self.setValue(AppColors.datePickerText, forKey: "textColor")
//            toolbar.barTintColor = UIColor(displayP3Red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
//            cancelButton.tintColor = toolBarTint ?? UIColor(displayP3Red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
//            doneButton.tintColor = toolBarTint ?? UIColor(displayP3Red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
//        }
        
        let array = [spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        
        toolbar.backgroundColor = .clear
        toolbar.barTintColor = AppColors.datePickerToolbarColor
        
        let genericPickerView: UIView = UIView()
        let pickerSize: CGSize = UIPickerView.pickerSize
        self.frame = CGRect(x: 0, y: 0, width: pickerSize.width, height: pickerSize.height)
        genericPickerView.addSubview(self)
        genericPickerView.frame = CGRect(x: 0, y: 0, width: pickerSize.width, height: pickerSize.height)
        genericPickerView.backgroundColor = AppColors.quaternarySystemFillColor
        //genericPickerView.addBlurEffect(backgroundColor: AppColors.quaternarySystemFillColor, style: .dark, alpha: 1.0)
        
        
        textField?.inputView = genericPickerView
        textField?.inputAccessoryView = toolbar
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        var selected = self.dateFormatter.string(from: sender.date)
        if self.isErroType{
            var isError:Bool = false
            var errorType:DatePickerError? = nil
            if let mxDate = self.maxDate,  (sender.date > mxDate){
                isError = true
                errorType = .maxExceed
                sender.setDate(mxDate, animated: true)
                selected = self.dateFormatter.string(from: mxDate)
            }else if let mnDate = self.minDate, (mnDate > sender.date){
                isError = true
                errorType = .minExceed
                sender.setDate(mnDate, animated: true)
                selected = self.dateFormatter.string(from: mnDate)
            }
            
            self.doneBlockWithError?(selected,isError, errorType)
            return
        }
        self.doneBlock?(selected)
    }
    
    @IBAction private func pickerCancelButtonTapped(){
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    @IBAction private func pickerDoneButtonTapped(){
        UIApplication.shared.keyWindow?.endEditing(true)
        
        let selected = self.dateFormatter.string(from: self.date)
        if self.isErroType{
            var isError:Bool = false
            var errorType:DatePickerError? = nil
            if let mxDate = self.maxDate,  (self.date > mxDate){
                isError = true
                errorType = .maxExceed
                self.setDate(mxDate, animated: true)
            }else if let mnDate = self.minDate, (mnDate > self.date){
                isError = true
                errorType = .minExceed
                self.setDate(mnDate, animated: true)
            }
            
            self.doneBlockWithError?(selected,isError, errorType)
            return
        }
        
        self.doneBlock?(selected)
    }
}
