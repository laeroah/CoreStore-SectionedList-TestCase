//
//  Continent+CoreDataProperties.swift
//  
//
//  Created by James Bebbington on 22/09/2016.
//
//

import Foundation
import CoreData


extension Continent {

    @NSManaged public var name: String
    @NSManaged public var countries: NSSet

}
