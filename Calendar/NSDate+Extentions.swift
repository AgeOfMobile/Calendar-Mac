//
//  NSDate+Extentions.swift
//  Calendar
//
//  Created by Tri on 4/25/15.
//  Copyright (c) 2015 Age Of Mobile. All rights reserved.
//

import Foundation

extension NSDate {
    var day : Int {
        get {
            var calendar = NSCalendar.currentCalendar()
            var components = calendar.components(.CalendarUnitDay, fromDate: self)
            return components.day
        }
    }
    
    func isToday() -> Bool {
        var calendar = NSCalendar.currentCalendar()
        return calendar.isDateInToday(self)
    }
    
    func isWeekend() -> Bool {
        var calendar = NSCalendar.currentCalendar()
        return calendar.isDateInWeekend(self)
    }
    
    func dateByAddingDays(days: Int) -> NSDate {
        var calendar = NSCalendar.currentCalendar()
        return calendar.dateByAddingUnit(.CalendarUnitDay, value: days, toDate: self, options: nil)!
    }
    
    func dateByAddingMonths(months: Int) -> NSDate {
        var calendar = NSCalendar.currentCalendar()
        return calendar.dateByAddingUnit(.CalendarUnitMonth, value: months, toDate: self, options: nil)!
    }
    
    func beginOfMonth() -> NSDate {
        var calendar = NSCalendar.currentCalendar()
        var components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: self)
        components.day = 1
        return calendar.dateFromComponents(components)!
    }
    
    func daysOfMonth() -> Int {
        var calendar = NSCalendar.currentCalendar()
        return calendar.rangeOfUnit(.CalendarUnitDay, inUnit: .CalendarUnitMonth, forDate: self).length
    }
}