//
//  AppDelegate.swift
//  CoreStoreSectionedListTestCase
//
//  Created by James Bebbington on 22/09/2016.
//  Copyright © 2016 Liveminds. All rights reserved.
//

import UIKit
import CoreData
import CoreStore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let persistentStore = try! CoreStore.addStorageAndWait()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        if CoreStore.queryValue(From(Country), Select<Int>(.Count("name"))) == 0 {
            seedDatabase()
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func seedDatabase() {
        let countries = [
            "Africa": [
                "Ivory Coast",
                "South Africa"
            ],
            "Europe": [
                "France",
                "Germany",
                "Spain",
                "UK"
            ],
            "Asia": [
                "China",
                "Japan",
            ]
        ]

        print("Seeding database…")
        for (continentName, countryNames) in countries {
            CoreStore.beginAsynchronous { (transaction) -> Void in

                // Importing continent
                let continent = transaction.create(Into(Continent))
                continent.name = continentName

                transaction.commit{ (result) -> Void in
                    switch result {
                    case .Success:

                        // Importing country
                        for countryName in countryNames {
                            let continent = CoreStore.fetchOne(From(Continent), Where("name == %@", continentName))!
                            CoreStore.beginAsynchronous { (transaction) -> Void in
                                let continent = transaction.fetchExisting(continent)!
                                let country = transaction.create(Into(Country))
                                country.continent = continent
                                country.name = countryName

                                transaction.commit{ (result) -> Void in
                                    switch result {
                                    case .Success:
                                        break
                                    case .Failure(let error):
                                        print(error)
                                    }
                                }
                                
                            }
                        }

                    case .Failure(let error):
                        print(error)
                    }
                }
            }

        }
    }
}

