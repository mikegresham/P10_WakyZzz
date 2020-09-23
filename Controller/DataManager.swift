//
//  DataM.swift
//  WakyZzz
//
//  Created by Michael Gresham on 23/08/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import UIKit
import Foundation
import CoreData

protocol DataManagerDelegate {
    
}

class DataManager {
    var context: NSManagedObjectContext
    var entity: NSEntityDescription?
    
    static let shared = DataManager()
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.newBackgroundContext()
        entity = NSEntityDescription.entity(forEntityName: Alarm.entityName, in: context)
    }
    
    //MARK: Create
    
    func createNewAlarm(id: UUID, time: Int, repeatDays: [Bool], enabled: Bool) {
        let newAlarm = NSEntityDescription.insertNewObject(forEntityName: Alarm.entityName, into: context) as! Alarm
        
        newAlarm.id = id
        newAlarm.time = time
        newAlarm.repeatDays = repeatDays
        newAlarm.enabled = enabled
        newAlarm.snoozeCounter = 0
        
        saveContext()
    }
    
    //MARK: Read
    
    func fetchAlarm(id: UUID) -> Alarm? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Alarm.entityName)
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Alarm.id), id as CVarArg)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(fetchRequest) as! [Alarm]
            return result.first
        } catch { print("Fetch on alarm id: \(id) failed. \(error)")}
        return nil
    }
    
    func fetchAlarmHistory() -> [Alarm]? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: Alarm.entityName)
        
        let sectionSortDescriptor = NSSortDescriptor(key: "time", ascending: true)
        fetchRequest.sortDescriptors = [sectionSortDescriptor]
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(fetchRequest) as! [Alarm]
            return result
        }
        catch {
            
        }
        return nil
    }
    
    //MARK: Update
    
    func updateAlarm(alarm: Alarm) {
        if fetchAlarm(id: alarm.id) != nil {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: Alarm.entityName)
            request.predicate = NSPredicate(format: "%K == %@", #keyPath(Alarm.id), alarm.id as CVarArg)
             do {
                 let result = try context.fetch(request)
                 if let returnedResult = result as? [Alarm] {
                     if returnedResult.count != 0 {
                        let returnedAlarm = returnedResult.first!
                        returnedAlarm.time = alarm.time
                        returnedAlarm.repeatDays = alarm.repeatDays
                        returnedAlarm.enabled = alarm.enabled
                        returnedAlarm.snoozeCounter = alarm.snoozeCounter
            
                         saveContext()
                     } else {
                        print("Fetch result was empty for specified film id: \(alarm.id)")
                        self.createNewAlarm(id: alarm.id, time: alarm.time, repeatDays: alarm.repeatDays, enabled: alarm.enabled)
                        print("Created new film: \(alarm.id)")
                    }
                 }
            } catch {
                }
        } else {
            deleteAlarm(for: alarm.id)
        }
        
    }
    
    //MARK: Delete
    
    func deleteAlarm(for id: UUID) {
        if fetchAlarm(id: id) != nil {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: Alarm.entityName)
                  request.predicate = NSPredicate(format: "%K == %@", #keyPath(Alarm.id), id as CVarArg)
                  request.returnsObjectsAsFaults = false
                  do {
                      let result = try context.fetch(request) as! [Alarm]
                      context.delete(result.first!)
                  } catch {
                      print("Failed to delted alarm with id:\(id)")
                  }
                  saveContext()
        } else {
            print("Alarm for id: \(id) does not exist")
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        }
        catch {
            print("Save failed: \(error)")
            context.rollback()
        }
    }
}
