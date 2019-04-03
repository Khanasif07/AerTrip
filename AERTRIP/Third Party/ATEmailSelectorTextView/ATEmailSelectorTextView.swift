//
//  ATEmailSelectorTextView.swift
//  NewDemo
//
//  Created by Pramod Kumar on 11/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ATEmailSelectorTextView: UITextView {

    //MARK:- Proverties
    //MARK:- Private
    private var oldText: String = ""
    private var isLastTagSelected: Bool = false
    private var _tagSeparator: String = ","
    
    private var textRemovingWhitespacesAndNewlines: String {
        let components = text.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: "")
    }
    
    private var allTags: [String] {
        var arr = textRemovingWhitespacesAndNewlines.components(separatedBy: _tagSeparator).reduce(into: [""]) { (unique, element) in
            if !element.isEmpty, !unique.contains(element) {
                unique.append(element)
            }
        }
        
        arr.removeFirst()
        return arr
    }
    
    private var tagsString: String {
        return allTags.joined(separator: tagSeparator) + (allTags.isEmpty ? "" : tagSeparator)
    }
    
    //MARK:- Public
    var isSeparatorFollowedBySpace: Bool = true
    
    var tagSeparator: String {
        set {
            _tagSeparator = tagSeparator
        }
        
        get {
            return _tagSeparator + (isSeparatorFollowedBySpace ? " " : "")
        }
    }
    
    var tagSeparatorColor: UIColor = UIColor.black {
        didSet {
            setUpTagSeparatorConfiguration()
        }
    }
    
    var tagSeparatorFont: UIFont = UIFont.systemFont(ofSize: 15.0) {
        didSet {
            setUpTagSeparatorConfiguration()
        }
    }
    
    var inactiveTagFontColor: UIColor = UIColor.blue {
        didSet {
            setUpTagsConfiguration()
        }
    }
    
    var inactiveTagBackgroundColor: UIColor = UIColor.white {
        didSet {
            setUpTagsConfiguration()
        }
    }
    
    var activeTagBackgroundColor: UIColor = UIColor.blue {
        didSet {
            setUpTagsConfiguration()
        }
    }
    
    var activeTagFontColor: UIColor = UIColor.white {
        didSet {
            setUpTagsConfiguration()
        }
    }
    
    var activeTagFont: UIFont = UIFont.systemFont(ofSize: 15.0) {
        didSet {
            setUpTagsConfiguration()
        }
    }
    
    var inactiveTagFont: UIFont = UIFont.systemFont(ofSize: 15.0) {
        didSet {
            setUpTagsConfiguration()
        }
    }
    
    override var text: String! {
        didSet {
            _ = heighlightAllTags()
        }
    }
    
    //MARK:- Life Cycle
    //MARK:-
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialSetup()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK:- Methods
    //MARK:- Private
    private func initialSetup() {
        addNotificationForDelegate()
    }
    
    private func addNotificationForDelegate() {
        //Add Notification for Text View Delegates
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextView.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidBeginEditing(_:)), name: UITextView.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidEndEditing(_:)), name: UITextView.textDidEndEditingNotification, object: nil)
    }
    
    @objc private func textDidChange(_ sender : Foundation.Notification) {
        if text.count <= 1 {
            attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : tagSeparatorColor, NSAttributedString.Key.font: tagSeparatorFont])
        }
        if oldText.count < text.count {
            //adding chars
            
            //heighlight All Tags if last char is tagSeparator
            if let char = text.last, ("\(char)" == _tagSeparator || "\(char)" == tagSeparator) {
                _ = heighlightAllTags()
            }
        }
        else {
            //removing chars
            
            //select last tag if deleting tagSeparator
            if let char = text.last, ("\(char)" == _tagSeparator || "\(char)" == tagSeparator) {
                if isLastTagSelected {
                    removeLastTag()
                }
                else {
                    makeSelectionForLastTag()
                }
            }
        }
        print(text)
        oldText = text
    }
    
    @objc private func textViewDidBeginEditing(_ sender : Foundation.Notification) {
        
    }
    
    @objc private func textViewDidEndEditing(_ sender : Foundation.Notification) {
    }
    
    private func heighlightAllTags() -> NSMutableAttributedString {
        let allTags = self.allTags
        
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: tagsString, attributes: [NSAttributedString.Key.foregroundColor : tagSeparatorColor, NSAttributedString.Key.font: tagSeparatorFont])
        
        for tag in allTags {
            attString.addAttributes([NSAttributedString.Key.font: inactiveTagFont, NSAttributedString.Key.foregroundColor : inactiveTagFontColor, NSAttributedString.Key.backgroundColor: inactiveTagBackgroundColor], range: (text as NSString).range(of: tag))
        }
        attributedText = attString
        isLastTagSelected = false
        
        return attString
    }
    
    private func makeSelectionForLastTag() {
        
        let attString = heighlightAllTags()
        
        if let lastTag = allTags.last {
            attString.addAttributes([NSAttributedString.Key.font: activeTagFont, NSAttributedString.Key.foregroundColor : activeTagFontColor, NSAttributedString.Key.backgroundColor: activeTagBackgroundColor], range: (text as NSString).range(of: lastTag))
            isLastTagSelected = true
        }
        
        attributedText = attString
    }
    
    private func removeLastTag() {
        var allTags = self.allTags
        allTags.removeLast()
        
        text = allTags.joined(separator: tagSeparator) + (allTags.isEmpty ? "" : tagSeparator)
    }
    
    private func setUpTagSeparatorConfiguration() {
        textColor = tagSeparatorColor
        font = tagSeparatorFont
    }
    
    private func setUpTagsConfiguration() {
        
    }
    
    //MARK:- Public
}
