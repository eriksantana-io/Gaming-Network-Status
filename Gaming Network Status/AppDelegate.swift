//
//  AppDelegate.swift
//  Gaming Network Status
//
//  Created by Erik Santana on 1/29/15.
//  Copyright (c) 2015 Erik Santana. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
    
    //Variables
    @IBOutlet weak var menuStatus: NSMenu!
    @IBOutlet weak var imgvPSNStatus: NSImageView!
    @IBOutlet weak var imgvXboxLiveStatus: NSImageView!
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    //Setup status bar icon
    func applicationDidFinishLaunching(aNotification: NSNotification)
    {
        
        let icon = NSImage(named: "imgsetStatusIcon")
        icon?.setTemplate(true)
        statusItem.image = icon
        statusItem.menu = menuStatus
        
    }
    
    
    @IBAction func menuQuit(sender: NSMenuItem) {
        
        NSApplication.sharedApplication().terminate(nil)
    }
    
    //Refresh button clicked
    @IBAction func btnRefreshClicked(sender: NSMenuItem)
    {
        
        let gamingNetworkData = ["https://support.us.playstation.com/app/answers/detail/a_id/237/~/psn-status%3A-online" : "PSN Status: Online" , "http://support.xbox.com/en-US/xbox-live-status" : "Xbox Live Core Services.*?up and running"]
        
        for (url, regex) in gamingNetworkData
        {
            let url = NSURL(string: url)
            let request = NSURLRequest(URL: url!)
            var queue: NSOperationQueue = NSOperationQueue()
            
            //Grab website
            
            NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) -> Void in
                
                if error != nil
                {
                    println(error.description)
                }
                else
                {
                    //Converting data to String
                    var responseStr:NSString = NSString(data:responseData, encoding:NSUTF8StringEncoding)!
                    let myStringToBeMatched = responseStr as String
                    
                    //Check network status
                    
                    if let match = myStringToBeMatched.rangeOfString(regex, options: .RegularExpressionSearch)
                    {
                        
                        println("Network is online!")
                        
                        if regex == "PSN Status: Online"
                        {
                            self.imgvPSNStatus.image = NSImage(named: "imgsetGreenIcon")
                        }
                        else
                        {
                            self.imgvXboxLiveStatus.image = NSImage(named: "imgsetGreenIcon")
                        }
                    }
                    else
                    {
                        println("Network is down!")
                        
                        if regex == "PSN Status: Online"
                        {
                            self.imgvPSNStatus.image = NSImage(named: "imgsetRedIcon")
                        }
                        else
                        {
                            self.imgvXboxLiveStatus.image = NSImage(named: "imgsetRedIcon")
                        }
                    }
                    
                }
            })
            
        }

            
    }
}


