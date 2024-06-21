import XCTest

final class ToDoListAppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // No cleanup needed for these tests
    }

    func testAddTask() throws {
        let app = XCUIApplication()
        
        let addButton = app.navigationBars["To-Do List"].buttons["AddTaskButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()

        let newTaskField = app.textFields["NewTaskTextField"]
        XCTAssertTrue(newTaskField.waitForExistence(timeout: 5))
        newTaskField.tap()
        newTaskField.typeText("New Task")
        
        let addTaskButton = app.buttons["AddButton"]
        XCTAssertTrue(addTaskButton.waitForExistence(timeout: 5))
        addTaskButton.tap()
        
        let taskTitle = app.staticTexts["TaskTitle_New Task"]
        XCTAssertTrue(taskTitle.waitForExistence(timeout: 5))
    }

    func testEditTask() throws {
        let app = XCUIApplication()
        
        // Add a sample task first to ensure there's something to edit
        let addButton = app.navigationBars["To-Do List"].buttons["AddTaskButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()

        let newTaskField = app.textFields["NewTaskTextField"]
        XCTAssertTrue(newTaskField.waitForExistence(timeout: 5))
        newTaskField.tap()
        newTaskField.typeText("Sample Task")
        
        let addTaskButton = app.buttons["AddButton"]
        XCTAssertTrue(addTaskButton.waitForExistence(timeout: 5))
        addTaskButton.tap()
        
        let sampleTask = app.staticTexts["TaskTitle_Sample Task"]
        XCTAssertTrue(sampleTask.waitForExistence(timeout: 5))
        sampleTask.tap()

        let taskTitleField = app.textFields["TaskTitleTextField"]
        XCTAssertTrue(taskTitleField.waitForExistence(timeout: 5))
        taskTitleField.tap()
        taskTitleField.clearText()
        taskTitleField.typeText("Edited Task")

        let saveButton = app.navigationBars["Task Details"].buttons["Save"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 5))
        saveButton.tap()

        // Navigate back to the To-Do List
        let backButton = app.navigationBars.buttons["To-Do List"]
        XCTAssertTrue(backButton.waitForExistence(timeout: 5))
        backButton.tap()
        
        XCTAssertTrue(app.staticTexts["TaskTitle_Edited Task"].exists)
    }

    func testDeleteTask() throws {
        let app = XCUIApplication()
    

        // Add a new task first to ensure there's something to delete
        let addButton = app.navigationBars["To-Do List"].buttons["AddTaskButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5), "Add Task Button does not exist")
        addButton.tap()

        let newTaskField = app.textFields["NewTaskTextField"]
        XCTAssertTrue(newTaskField.waitForExistence(timeout: 5), "New Task Text Field does not exist")
        newTaskField.tap()
        newTaskField.typeText("Delete Task")
        
        let addTaskButton = app.buttons["AddButton"]
        XCTAssertTrue(addTaskButton.waitForExistence(timeout: 5), "Add Button does not exist")
        addTaskButton.tap()

        // Verify the task was added
        let newTask = app.staticTexts["TaskTitle_Delete Task"]
        XCTAssertTrue(newTask.waitForExistence(timeout: 5), "New Task does not exist after adding")

        // Swipe left on the task to reveal the delete button
        newTask.swipeLeft()
        
        // Verify the delete button appears
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 5), "Delete Button does not exist after swiping left")

        // Tap the delete button
        deleteButton.tap()
        
        // Verify the task is no longer present
        XCTAssertFalse(app.staticTexts["TaskTitle_Delete Task"].exists, "Delete Task still exists after attempting to delete")
    }
    
    
    
    func takeScreenshot(name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else {
            return
        }
        self.tap()
        let deleteString = stringValue.map { _ in "\u{8}" }.joined(separator: "")
        self.typeText(deleteString)
    }
}
