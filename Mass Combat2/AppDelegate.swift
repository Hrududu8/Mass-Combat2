//
//  AppDelegate.swift
//  Mass Combat2
//
//  Created by rukesh on 11/14/15.
//  Copyright © 2015 Rukesh. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    var masterViewController : MasterViewController!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        masterViewController = MasterViewController(nibName: "MasterViewController", bundle: nil)
        window.contentView?.addSubview(masterViewController.view)
        masterViewController.view.frame = (window.contentView)!.bounds
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

