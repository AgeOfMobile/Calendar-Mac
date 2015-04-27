//
// Created by Tri on 4/24/15.
// Copyright (c) 2015 Age Of Mobile. All rights reserved.
//

import Foundation
import Cocoa

class CalendarView : NSView {
    let horizontalPadding: CGFloat = 5
    let verticalPadding: CGFloat = 5
    let cellWidth: CGFloat = 40
    let cellHeight: CGFloat = 40
    let font : NSFont! = NSFont(name: "HelveticaNeue-Light", size: 15.0)
    
    var titleBackgroundColor = NSColor.clearColor()
    var backgroundColor = NSColor.whiteColor()
    var dayOfWeekBackgroundColor = NSColor.clearColor()
    var previousMonthIcon = NSImage(named: "NSLeftFacingTriangleTemplate")
    var nextMonthIcon = NSImage(named: "NSRightFacingTriangleTemplate")

    var previousMonthView : NSButton!
    var nextMonthView : NSButton!
    var monthLabelView: NSTextField!
    var dayCells : [CalendarCell] = []

    var date: NSDate = NSDate()
    var monthFormatter : NSDateFormatter = NSDateFormatter()
    let calendar = NSCalendar.currentCalendar()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        monthFormatter.dateFormat = "MMMM, yyyy"
        initViews()
        updateViews();
    }

    func initViews() {
        let width = CGFloat(8.0 * horizontalPadding + 7.0 * cellWidth)
        let height = CGFloat(8.0 * verticalPadding + 8.0 * cellHeight)
        NSLayoutConstraint.activateConstraints([
                NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal,
                        toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: width),
                NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal,
                        toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: height)
        ])

        // layout title views
        previousMonthView = NSButton(frame: CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight))
        previousMonthView.image = previousMonthIcon
        previousMonthView.translatesAutoresizingMaskIntoConstraints = false
        previousMonthView.bordered = false
        addSubview(previousMonthView)
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint(item: previousMonthView, attribute: .Left, relatedBy: .Equal,
                    toItem: self, attribute: .Left, multiplier: 1.0, constant: horizontalPadding),
            NSLayoutConstraint(item: previousMonthView, attribute: .Width, relatedBy: .Equal,
                toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: cellWidth),
            NSLayoutConstraint(item: previousMonthView, attribute: .Height, relatedBy: .Equal,
                toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: cellHeight),
            NSLayoutConstraint(item: previousMonthView, attribute: .Top, relatedBy: .Equal,
                    toItem: self, attribute: .Top, multiplier: 1.0, constant: verticalPadding)
        ])
        previousMonthView.action = Selector("previousMonth")
        previousMonthView.target = self

        nextMonthView = NSButton(frame: CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight))
        nextMonthView.image = nextMonthIcon
        nextMonthView.translatesAutoresizingMaskIntoConstraints = false
        nextMonthView.bordered = false
        addSubview(nextMonthView)
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint(item: nextMonthView, attribute: .Right, relatedBy: .Equal,
                toItem: self, attribute: .Right, multiplier: 1.0, constant: -horizontalPadding),
            NSLayoutConstraint(item: nextMonthView, attribute: .Width, relatedBy: .Equal,
                toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: cellWidth),
            NSLayoutConstraint(item: nextMonthView, attribute: .Height, relatedBy: .Equal,
                toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: cellHeight),
            NSLayoutConstraint(item: nextMonthView, attribute: .Top, relatedBy: .Equal,
                toItem: self, attribute: .Top, multiplier: 1.0, constant: verticalPadding)
        ])
        nextMonthView.action = Selector("nextMonth")
        nextMonthView.target = self

        monthLabelView = NSTextField(frame: CGRect.zeroRect)
        monthLabelView.stringValue = monthTitle()
        monthLabelView.editable = false
        monthLabelView.font = font
        monthLabelView.backgroundColor = titleBackgroundColor
        monthLabelView.alignment = .CenterTextAlignment
        monthLabelView.translatesAutoresizingMaskIntoConstraints = false
        monthLabelView.bordered = false
        addSubview(monthLabelView)
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint(item: monthLabelView, attribute: .Left, relatedBy: .Equal,
                    toItem: previousMonthView, attribute: .Right, multiplier: 1.0, constant: horizontalPadding),
            NSLayoutConstraint(item: monthLabelView, attribute: .CenterY, relatedBy: .Equal,
                    toItem: previousMonthView, attribute: .CenterY, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: monthLabelView, attribute: .Right, relatedBy: .Equal,
                    toItem: nextMonthView, attribute: .Left, multiplier: 1.0, constant: -horizontalPadding),
            NSLayoutConstraint(item: nextMonthView, attribute: .Height, relatedBy: .Equal,
                toItem: previousMonthView, attribute: .Height, multiplier: 1.0, constant: 0)
        ])

        // layout day label views
        var previousCell : NSView = self
        let widthMultiplier : CGFloat = 1.0 / 7.0
        for i in 0...6 {
            var dayLabel = NSTextField(frame: CGRect.zeroRect)
            dayLabel.stringValue = "\(calendar.shortWeekdaySymbols[i])"
            dayLabel.editable = false
            dayLabel.font = font
            dayLabel.backgroundColor = dayOfWeekBackgroundColor
            dayLabel.alignment = .CenterTextAlignment
            dayLabel.translatesAutoresizingMaskIntoConstraints = false
            dayLabel.bordered = false
            addSubview(dayLabel)
            NSLayoutConstraint.activateConstraints([
                NSLayoutConstraint(item: dayLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal,
                    toItem: previousCell, attribute: previousCell == self ? NSLayoutAttribute.Left : NSLayoutAttribute.Right, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: dayLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
                    toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: CGFloat(verticalPadding + cellHeight)),
                NSLayoutConstraint(item: dayLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
                    toItem: self, attribute: NSLayoutAttribute.Width, multiplier: widthMultiplier, constant: 0),
                NSLayoutConstraint(item: dayLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
                    toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: cellHeight)
            ])
            previousCell = dayLabel
        }

        // layout days of month views
        var index: Int = 0
        for row in 0...5 {
            previousCell = self
            for col in 0...6 {
                var dayCell = CalendarCell(frame: CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight))
                dayCell.font = font
                dayCell.translatesAutoresizingMaskIntoConstraints = false
                dayCell.bordered = false
                addSubview(dayCell)
                let topConstraint : CGFloat =  CGFloat(2 + row) * (cellHeight + verticalPadding)
                NSLayoutConstraint.activateConstraints([
                    NSLayoutConstraint(item: dayCell, attribute: .Left, relatedBy: .Equal,
                        toItem: previousCell, attribute: previousCell == self ? .Left : .Right, multiplier: 1.0, constant: horizontalPadding),
                    NSLayoutConstraint(item: dayCell, attribute: .Top, relatedBy: .Equal,
                        toItem: self, attribute: .Top, multiplier: 1.0, constant: topConstraint),
                    NSLayoutConstraint(item: dayCell, attribute: .Width, relatedBy: .Equal,
                        toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: cellWidth),
                    NSLayoutConstraint(item: dayCell, attribute: .Height, relatedBy: .Equal,
                        toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: cellHeight)
                ])
                previousCell = dayCell
                dayCells.append(dayCell)
                index++
            }
        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        backgroundColor.setFill()
        NSRectFill(self.bounds)
    }
    
    func previousMonth() {
        date = date.dateByAddingMonths(-1)
        updateViews()
    }
    
    func nextMonth() {
        date = date.dateByAddingMonths(1)
        updateViews()
    }

    func monthTitle() -> String {
        return monthFormatter.stringFromDate(self.date);
    }

    func updateViews() {
        monthLabelView.stringValue = monthTitle()
        
        var beginOfMonthDate = date.beginOfMonth()
        var weekday = calendar.component(.CalendarUnitWeekday, fromDate: beginOfMonthDate)
        var firstDayOfMonthIndex = weekday - calendar.firstWeekday
        var lastDayIndex = firstDayOfMonthIndex + date.daysOfMonth() - 1
        var currentDate = beginOfMonthDate.dateByAddingDays(-firstDayOfMonthIndex)
        for index in 0..<dayCells.count {
            var cell : CalendarCell = dayCells[index]
            cell.date = currentDate;
            if index < firstDayOfMonthIndex || index > lastDayIndex {
                cell.otherMonths = true
            } else {
                cell.otherMonths = false
            }
            cell.update()
            currentDate = currentDate.dateByAddingDays(1)
        }
    }
}
