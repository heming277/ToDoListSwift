//
//  TaskItem+CoreDataProperties.swift
//  ToDoListApp
//
//  Created by Heming Liu on 2024-06-20.
//
//

import Foundation
import CoreData

extension TaskItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskItem> {
        return NSFetchRequest<TaskItem>(entityName: "TaskItem")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var title: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var body: String?
}

extension TaskItem: Identifiable {
}
