//
//  AppDelegate.swift
//  Kleper
//
//  Created by Zaitam on 31/05/2021.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var clipboardItems: [String] = [] //List of items
    let clipboard = Clipboard() //ClipoboardFunction
    let numberOfItems = 5
    var window: NSWindow!//Window
    //MenuBarItems
    var statusBarItem: NSStatusItem!
    var statusBarMenu = NSMenu(title: "Item")

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
        statusBarItem.button?.image = NSImage(systemSymbolName: "doc.on.clipboard", accessibilityDescription: "")
        statusBarItem.menu = statusBarMenu

        //MenuBar
        statusBarMenu.addItem(NSMenuItem.separator())
        statusBarMenu.addItem(
                withTitle: "Delete all items",
                action: #selector(AppDelegate.DeleteAllItems),
                keyEquivalent: "d"
        )
        statusBarMenu.addItem(
                withTitle: "Quit",
                action: #selector(AppDelegate.Quit),
                keyEquivalent: "q"
        )
        //React to clipboard changes
        clipboard.startListening()
        clipboard.onNewCopy { [self] (content) in
            if clipboardItems.contains(content){return} //Don't copy dulpicated

            let item = NSMenuItem()
            item.title = String(content.prefix(25))
            item.action = #selector(self.GetItem(sender:))

            //Add items
            clipboardItems.insert(content, at: 0)
            statusBarMenu.insertItem(item, at: 0)
            //Delete if item if they are over the max defined by user
            if (statusBarMenu.numberOfItems - 4 >= numberOfItems){
                statusBarMenu.removeItem(at: statusBarMenu.numberOfItems - 4)
                clipboardItems.removeLast(clipboardItems.count - numberOfItems)
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func DeleteAllItems() {
        if (statusBarMenu.numberOfItems > 3){
            for _ in 0...(statusBarMenu.numberOfItems - 4) {
                statusBarMenu.removeItem(at: 0)
            }}
        clipboardItems.removeAll()
    }

    @objc func Quit() {
        NSApp.terminate(self)
    }

    @objc func GetItem(sender: NSMenuItem) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(clipboardItems[statusBarMenu.index(of: sender)], forType: .string)
    }
}
