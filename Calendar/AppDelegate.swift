//
//  AppDelegate.swift
//  Calendar
//
//  Created by Tri on 4/24/15.
//  Copyright (c) 2015 Age Of Mobile. All rights reserved.
//


import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var popover: NSPopover!
    
    private var popoverTransiencyMonitor : AnyObject!
    private let icon: IconView;

    override init() {
        let bar = NSStatusBar.systemStatusBar()

        let length: CGFloat = -1 //NSVariableStatusItemLength
        let item = bar.statusItemWithLength(length)

        self.icon = IconView(imageName: "calendar", item: item)
        item.view = icon

        super.init()
    }

    override func awakeFromNib() {
        self.popover?.appearance = NSAppearance(named: NSAppearanceNameAqua)
        let edge = NSMinYEdge
        let icon = self.icon
        let rect = icon.frame

        icon.onMouseDown = {
            if (icon.isSelected) {
                self.popover?.showRelativeToRect(rect, ofView: icon, preferredEdge: edge)
                if (self.popoverTransiencyMonitor == nil) {
                    self.popoverTransiencyMonitor = NSEvent.addGlobalMonitorForEventsMatchingMask((.LeftMouseDownMask | .RightMouseDownMask | .KeyUpMask),
                        handler: { (e: NSEvent!) -> Void in
                        icon.isSelected = false
                        NSEvent.removeMonitor(self.popoverTransiencyMonitor)
                        self.popoverTransiencyMonitor = nil
                        self.popover?.close()
                    })
                }
                return
            }
            self.popover?.close()
        }
    }
}
