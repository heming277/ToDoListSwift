import XCTest
import CoreData
@testable import ToDoListApp

final class ToDoListAppTests: XCTestCase {

    var persistenceController: PersistenceController!

    override func setUpWithError() throws {
        // Initialize the in-memory persistence controller for testing
        persistenceController = PersistenceController(inMemory: true)
    }

    override func tearDownWithError() throws {
        // Clean up
        persistenceController = nil
    }

    func testAddTask() throws {
        let context = persistenceController.container.viewContext
        let task = TaskItem(context: context)
        task.title = "Test Task"
        task.timestamp = Date()
        task.isCompleted = false

        try context.save()

        let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        let results = try context.fetch(fetchRequest)

        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.title, "Test Task")
    }

    func testUpdateTask() throws {
        let context = persistenceController.container.viewContext
        let task = TaskItem(context: context)
        task.title = "Initial Task"
        task.timestamp = Date()
        task.isCompleted = false

        try context.save()

        task.title = "Updated Task"
        try context.save()

        let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        let results = try context.fetch(fetchRequest)

        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.title, "Updated Task")
    }

    func testDeleteTask() throws {
        let context = persistenceController.container.viewContext
        let task = TaskItem(context: context)
        task.title = "Task to be deleted"
        task.timestamp = Date()
        task.isCompleted = false

        try context.save()

        context.delete(task)
        try context.save()

        let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        let results = try context.fetch(fetchRequest)

        XCTAssertEqual(results.count, 0)
    }
}
