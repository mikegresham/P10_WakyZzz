//
//  AlarmsViewController.swift
//  WakyZzz
//
//  Created by Olga Volkova on 2018-05-30.
//  Copyright © 2018 Olga Volkova OC. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AlarmCellDelegate, AlarmViewControllerDelegate {
    
    //MARK: IBOutlets & Global Variables
    @IBOutlet weak var tableView: UITableView!
    
    var alarms = [Alarm]()
    var editingIndexPath: IndexPath?
    
    //MARK: Button Actions
    
    @IBAction func addButtonPress(_ sender: Any) {
        presentAlarmViewController(alarm: nil)
    }
    
    //MARK: Setup

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        config()
    }
    
    func config() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        populateAlarms()
        
    }
    
    //MARK: Functions
    
    func populateAlarms() {
                
        // MG - Fetch alarms from persistent data store
        if let alarms = DataManager.shared.fetchAlarmHistory(), alarms.count > 0 {
            self.alarms = alarms
        } else {
            //If fetch result is empty, create new alarm.
            DataManager.shared.createNewAlarm(id: UUID(), time: 8, repeatDays: [false, true, true, true, true, true, false ], enabled: true)
            self.alarms = DataManager.shared.fetchAlarmHistory()!
        }
        for alarm in alarms {
            NotificationManager.shared.scheduleAlarm(for: alarm)
        }
        //MG - removed creation if alarms on app launch
    }
    
    //MARK: TableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmTableViewCell
        cell.delegate = self
        if let alarm = alarm(at: indexPath) {
            cell.populate(caption: alarm.caption, subcaption: alarm.repeating, enabled: alarm.enabled)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //  MG - Updated function to UISwipeActionsConfiguration, as UITableViewAction was deprecated.
        let delete = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completion) in
            self.deleteAlarm(at: indexPath)
        }
        let edit = UIContextualAction(style: .normal, title: "Edit") {
            (action, view, completion) in
            self.editAlarm(at: indexPath)
        }
        return UISwipeActionsConfiguration.init(actions: [delete, edit])
        
    }
    
    func alarm(at indexPath: IndexPath) -> Alarm? {
        return indexPath.row < alarms.count ? alarms[indexPath.row] : nil
    }
    
    func deleteAlarm(at indexPath: IndexPath) {
        tableView.beginUpdates()
        // MG - App crash caused by removing at alarms.count (out of range), changed to indexPath.row
        print(alarms[indexPath.row].id)
        DataManager.shared.deleteAlarm(for: alarms[indexPath.row].id)
        alarms.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func editAlarm(at indexPath: IndexPath) {
        editingIndexPath = indexPath
        presentAlarmViewController(alarm: alarm(at: indexPath))
    }
    
    func addAlarm(_ alarm: Alarm, at indexPath: IndexPath) {
        tableView.beginUpdates()
        alarms.insert(alarm, at: indexPath.row)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func moveAlarm(from originalIndextPath: IndexPath, to targetIndexPath: IndexPath) {
        let alarm = alarms.remove(at: originalIndextPath.row)
        var indexPath = targetIndexPath
        indexPath.row = targetIndexPath.row == 0 ? 1 : targetIndexPath.row
        alarms.insert(alarm, at: indexPath.row - 1)
        tableView.reloadData()
    }
    
    func alarmCell(_ cell: AlarmTableViewCell, enabledChanged enabled: Bool) {
        if let indexPath = tableView.indexPath(for: cell) {
            if let alarm = self.alarm(at: indexPath) {
                alarm.enabled = enabled
                DataManager.shared.updateAlarm(alarm: alarm)
            }
        }
    }
    
    func presentAlarmViewController(alarm: Alarm?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popupViewController = storyboard.instantiateViewController(withIdentifier: "DetailNavigationController") as! UINavigationController
        let alarmViewController = popupViewController.viewControllers[0] as! AlarmViewController
        alarmViewController.alarm = alarm
        alarmViewController.delegate = self
        present(popupViewController, animated: true, completion: nil)
    }
    
    func alarmViewControllerDone(alarm: Alarm) {
        // MG - Updated to function to sort alarms into asceding time order, when edited or created.
        if let editingIndexPath = editingIndexPath {
            // MG - On alarm edit, alarm is moved to correct position in array
            let indexPath = getIndexPathForAlarm(alarm: alarm)
            moveAlarm(from: editingIndexPath, to: indexPath)
            tableView.reloadRows(at: [editingIndexPath], with: .automatic)
        } else if alarms.count == 0 {
            // MG - Exception to catch fault, when all alarms are deleted, new alarms is added at index 0.
            addAlarm(alarm, at: IndexPath(row: 0, section: 0))
        } else {
            let indexPath = getIndexPathForAlarm(alarm: alarm)
            addAlarm(alarm, at: indexPath)
        }
        editingIndexPath = nil
    }
    
    func getIndexPathForAlarm(alarm: Alarm) -> IndexPath {
        // MG - New fucntion to return the indexpath to insert or move alarm to.
        // MG - Loop through current alarms, to see if new alarm is earlier than any current alarms
        for i in 0 ..< alarms.count {
            if alarm.time < alarms[i].time {
                return IndexPath(row: i, section: 0)
            }
        }
        // MG - If new alarm is later, then insert at end of array.
        return IndexPath(row: alarms.count, section: 0)
    }
    
    func alarmViewControllerCancel() {
        editingIndexPath = nil
    }
}



