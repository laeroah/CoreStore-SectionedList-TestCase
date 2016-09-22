//
//  CountriesTableViewController.swift
//  CoreStoreSectionedListTestCase
//
//  Created by James Bebbington on 22/09/2016.
//  Copyright © 2016 Liveminds. All rights reserved.
//

import UIKit
import CoreStore

class CountriesTableViewController: UITableViewController {

    let countries: ListMonitor<Country> = CoreStore.monitorSectionedList(
        From(Country),
        SectionBy("continent.name"),
        OrderBy(.Ascending("continent.name"))
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        countries.addObserver(self)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return countries.numberOfSections()
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        let section = countries.sectionInfoAtIndex(section)
        return section.name
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.numberOfObjectsInSection(section)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("countryCell", forIndexPath: indexPath)
        let country = countries[indexPath]
        cell.textLabel?.text = country.name
        return cell
    }

    func setTableEnabled(enabled: Bool) {
        UIView.animateWithDuration(
            0.2,
            delay: 0,
            options: .BeginFromCurrentState,
            animations: { () -> Void in
                if let tableView = self.tableView {
                    tableView.alpha = enabled ? 1.0 : 0.5
                    tableView.userInteractionEnabled = enabled
                }
            },
            completion: nil
        )
    }

}

extension CountriesTableViewController: ListObserver {

    func listMonitorWillChange(monitor: ListMonitor<Country>) {
        self.tableView.beginUpdates()
    }

    func listMonitorDidChange(monitor: ListMonitor<Country>) {
        self.tableView.endUpdates()
    }

    func listMonitorWillRefetch(monitor: ListMonitor<Country>) {
        self.setTableEnabled(false)
    }

    func listMonitorDidRefetch(monitor: ListMonitor<Country>) {
        self.tableView.reloadData()
        self.setTableEnabled(true)
    }

}

extension CountriesTableViewController: ListObjectObserver {

    func listMonitor(monitor: ListMonitor<Country>, didInsertObject object: Country, toIndexPath indexPath: NSIndexPath) {
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    func listMonitor(monitor: ListMonitor<Country>, didDeleteObject object: Country, fromIndexPath indexPath: NSIndexPath) {
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    func listMonitor(monitor: ListMonitor<Country>, didUpdateObject object: Country, atIndexPath indexPath: NSIndexPath) {
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath) {
            let country = countries[indexPath]
            cell.textLabel?.text = country.name
        }
    }

    func listMonitor(monitor: ListMonitor<Country>, didMoveObject object: Country, fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        self.tableView.deleteRowsAtIndexPaths([fromIndexPath], withRowAnimation: .Automatic)
        self.tableView.insertRowsAtIndexPaths([toIndexPath], withRowAnimation: .Automatic)
    }

}

extension CountriesTableViewController: ListSectionObserver {

    func listMonitor(monitor: ListMonitor<Country>, didInsertSection sectionInfo: NSFetchedResultsSectionInfo, toSectionIndex sectionIndex: Int) {
        self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
    }

    func listMonitor(monitor: ListMonitor<Country>, didDeleteSection sectionInfo: NSFetchedResultsSectionInfo, fromSectionIndex sectionIndex: Int) {
        self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
    }

}

