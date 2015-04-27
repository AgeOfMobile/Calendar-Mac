//
// Created by Tri on 4/24/15.
// Copyright (c) 2015 Age Of Mobile. All rights reserved.
//

import Foundation
import Cocoa

class CalendarCell : NSButton {
    var otherMonths : Bool = false
    var date : NSDate = NSDate()
    var currentMonthAttributes : [NSObject: AnyObject]!
    var otherMonthAttributes : [NSObject: AnyObject]!

    var titleFont : NSFont = NSFont(name: "HelveticaNeue", size: 15.0)!
    var otherMonthTitleFont : NSFont = NSFont(name: "HelveticaNeue-Light", size: 15.0)!
    
    var backgroundColor = NSColor.whiteColor()
    var borderColor = NSColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
    var todayBackgroundColor = NSColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
    var weekendBackgroundColor = NSColor.whiteColor()
    
    var textColor = NSColor.blackColor()
    var otherMonthTextColor = NSColor.lightGrayColor()
    var todayTextColor = NSColor.blackColor()
    var weekendTextColor = NSColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)
    var otherMonthWeekendTextColor = NSColor.lightGrayColor()
    var otherMonthTodayTextColor = NSColor.lightGrayColor()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        self.wantsLayer = true
        self.layer?.cornerRadius = self.frame.size.width / 2
        self.layer?.borderColor = borderColor.CGColor
        self.layer?.borderWidth = 1.0
    }
    
    func update() {
        var buttonCell = self.cell() as! NSButtonCell
        if (date.isToday()) {
            self.layer?.backgroundColor = todayBackgroundColor.CGColor
        } else if (date.isWeekend()) {
            self.layer?.backgroundColor = weekendBackgroundColor.CGColor;
        } else {
            self.layer?.backgroundColor = backgroundColor.CGColor
        }
        self.attributedTitle = NSAttributedString(string: "\(date.day)", attributes: titleAttributes())
    }
    
    func titleAttributes() -> [NSObject: AnyObject]! {
        if (otherMonths) {
            if (otherMonthAttributes == nil) {
                otherMonthAttributes = commonTitleAttributes()
            }
            
            if (date.isToday()) {
                otherMonthAttributes[NSForegroundColorAttributeName] = otherMonthTodayTextColor
            } else if (date.isWeekend()) {
                otherMonthAttributes[NSForegroundColorAttributeName] = otherMonthWeekendTextColor
            } else {
                otherMonthAttributes[NSForegroundColorAttributeName] = otherMonthTextColor
            }
            otherMonthAttributes[NSFontAttributeName] = otherMonthTitleFont
            return otherMonthAttributes
            
        } else {
            if (currentMonthAttributes == nil) {
                currentMonthAttributes = commonTitleAttributes()
            }
            currentMonthAttributes[NSFontAttributeName] = titleFont
            
            if (date.isToday()) {
                currentMonthAttributes[NSForegroundColorAttributeName] = todayTextColor
            } else if (date.isWeekend()) {
                currentMonthAttributes[NSForegroundColorAttributeName] = weekendTextColor
            } else {
                currentMonthAttributes[NSForegroundColorAttributeName] = textColor;
            }
            return currentMonthAttributes
        }
    }
    
    func commonTitleAttributes() -> [NSObject: AnyObject] {
        var attributes : [NSObject: AnyObject] = [:]
        attributes[NSFontAttributeName] = titleFont
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .CenterTextAlignment
        attributes[NSParagraphStyleAttributeName] = paragraphStyle
        return attributes
    }
}
