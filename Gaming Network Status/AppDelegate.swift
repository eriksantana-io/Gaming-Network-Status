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
    
    //Outlets
    @IBOutlet weak var menuStatus: NSMenu!
    @IBOutlet weak var imgvPSNStatus: NSImageView!
    @IBOutlet weak var imgvXboxLiveStatus: NSImageView!
    @IBOutlet weak var imgvXboxLiveGamingStatus: NSImageView!
    
    //Globals
    struct myVars
    {
        static var psnDown = false
        static var xboxLiveCoreDown = false
        static var xboxLiveGamingDown = false
    }
    
    //Setup status bar icon and initial check
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    func applicationDidFinishLaunching(aNotification: NSNotification)
    {
        let icon = NSImage(named: "imgsetStatusIcon")
        icon?.setTemplate(true)
        statusItem.image = icon
        statusItem.menu = menuStatus
        
        checkNetworkStatus()
        sleep(3)
        setStatusLights()
    }
    
    //Quit Menu
    @IBAction func menuQuit(sender: NSMenuItem)
    {
        NSApplication.sharedApplication().terminate(nil)
    }
    
    //Function that checks for network status
    func checkNetworkStatus ()
    {
        //Dictionary - URL/REGEX
        let gamingNetworkData = ["https://support.us.playstation.com/app/answers/detail/a_id/237/~/psn-status%3A-online" : "PSN Status: Online" , "http://support.xbox.com/en-US/xbox-live-status" : "Xbox Live Core Services.*?up and running", "https://support.xbox.com/en-US/xbox-live-status" : "Social and Gaming.*?up and running"]
        
        //Iterate over dictionary data
        for (url, regex) in gamingNetworkData
        {
            let url = NSURL(string: url)
            let request = NSURLRequest(URL: url!)
            var queue: NSOperationQueue = NSOperationQueue()
            
            //Grab website
            NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) -> Void in
                
                sleep(2)
                
                //Error if website is not available
                if error != nil
                {
                    println(error.description)
                }
                else
                {
                    //Converting data to String
                    var responseStr:NSString = NSString(data:responseData, encoding:NSUTF8StringEncoding)!
                    let myStringToBeMatched = responseStr as String
                    
                    //Check network status using regex
                    if let match = myStringToBeMatched.rangeOfString(regex, options: .RegularExpressionSearch)
                    {
                        if regex == "PSN Status: Online"
                        {
                            myVars.psnDown = false
                            //println("PSN is online!")
                        }
                        
                        if regex == "Xbox Live Core Services.*?up and running"
                        {
                            myVars.xboxLiveCoreDown = false
                            //println("Xbox Live Core Services is online!")
                        }
                        
                        if regex == "Social and Gaming.*?up and running"
                        {
                            myVars.xboxLiveGamingDown = false
                            //println("Xbox Live Social and Gaming is online!")
                        }
                    }
                    else
                    {
                        if regex == "PSN Status: Online"
                        {
                            myVars.psnDown = true
                            //println("PSN is offline!")
                        }
                        
                        if regex == "Xbox Live Core Services.*?up and running"
                        {
                            myVars.xboxLiveCoreDown = true
                            //println("Xbox Live Core Services is offline!")
                        }
                        
                        if regex == "Social and Gaming.*?up and running"
                        {
                            myVars.xboxLiveGamingDown = true
                            //println("Xbox Live Social and Gaming is offline!")
                        }
                    }
                    
                }
            })
        }
    }
    
    //Function that sets green/red/grey status icon for each network
    func setStatusLights()
    {
        //Set PSN status light
        if myVars.psnDown == false
        {
            self.imgvPSNStatus.image = NSImage(named: "imgsetGreenIcon")
        }
        else if myVars.psnDown == true
        {
            self.imgvPSNStatus.image = NSImage(named: "imgsetRedIcon")
        }
        else
        {
            self.imgvPSNStatus.image = NSImage(named: "imgsetGreyIcon")
        }
        
        //Set Xbox Live Core status Light
        if myVars.xboxLiveCoreDown == false
        {
            self.imgvXboxLiveStatus.image = NSImage(named: "imgsetGreenIcon")
        }
        else if myVars.xboxLiveCoreDown == true
        {
            self.imgvXboxLiveStatus.image = NSImage(named: "imgsetRedIcon")
        }
        else
        {
            self.imgvXboxLiveStatus.image = NSImage(named: "imgsetGreyIcon")
        }
        
        //Set Xbox Live Social/Gaming status Light
        if myVars.xboxLiveGamingDown == false
        {
            self.imgvXboxLiveGamingStatus.image = NSImage(named: "imgsetGreenIcon")
        }
        else if myVars.xboxLiveGamingDown == true
        {
            self.imgvXboxLiveGamingStatus.image = NSImage(named: "imgsetRedIcon")
        }
        else
        {
            self.imgvXboxLiveGamingStatus.image = NSImage(named: "imgsetGreyIcon")
        }
        
    }
    
    //Refresh button clicked
    @IBAction func btnRefreshClicked(sender: NSMenuItem)
    {
        checkNetworkStatus()
        sleep(3)
        setStatusLights()
    }
    
}


