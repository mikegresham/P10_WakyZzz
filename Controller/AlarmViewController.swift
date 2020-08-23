//
//  AlarmViewController.swift
//  WakyZzz
//
//  Created by Olga Volkova on 2018-05-30.
//  Copyright © 2018 Olga Volkova OC. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import CoreData

protocol AlarmViewControllerDelegate {
    func alarmViewControllerDone(alarm: Alarm)
    func alarmViewControllerCancel()
}

class AlarmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    var alarm: Alarm?
    
    var delegate: AlarmViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        config()
    }
    
    func config() {        
        if alarm == nil {
            navigationItem.title = "New Alarm"
            let id = UUID()
            DataManager.shared.createNewAlarm(id: id, time: 8 * 3600, repeatDays: [false, false, false, false, false, false, false], enabled: true)
            alarm = DataManager.shared.fetchAlarm(id: id)
            
        }
        else {
            navigationItem.title = "Edit Alarm"
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        datePicker.date = (alarm?.alarmDate)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Alarm.daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayOfWeekCell", for: indexPath)
        cell.textLabel?.text = Alarm.daysOfWeek[indexPath.row]
        cell.accessoryType = (alarm?.repeatDays[indexPath.row])! ? .checkmark : .none
        if (alarm?.repeatDays[indexPath.row])! {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Repeat on following weekdays"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        alarm?.repeatDays[indexPath.row] = true
        tableView.cellForRow(at: indexPath)?.accessoryType = (alarm?.repeatDays[indexPath.row])! ? .checkmark : .none
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        alarm?.repeatDays[indexPath.row] = false
        tableView.cellForRow(at: indexPath)?.accessoryType = (alarm?.repeatDays[indexPath.row])! ? .checkmark : .none
    }
    
    @IBAction func cancelButtonPress(_ sender: Any) {
        if navigationItem.title == "New Alarm" {
            DataManager.shared.deleteAlarm(for: alarm!.id)
        }
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPress(_ sender: Any) {
        DataManager.shared.updateAlarm(alarm: alarm!)
        delegate?.alarmViewControllerDone(alarm: alarm!)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func datePickerValueChanged(_ sender: Any) {
        alarm?.setTime(date: datePicker.date)
    }
    
}
