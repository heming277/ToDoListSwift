import SwiftUI
import CoreData

struct TaskDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var task: TaskItem

    var body: some View {
        VStack(spacing: 20) {
            TextField("Task Title", text: $task.title.bound)
                .font(.headline)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .accessibilityIdentifier("TaskTitleTextField")
            
            TextEditor(text: $task.body.bound)
                .font(.body)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .frame(height: 200)
                .padding(.horizontal)
                .accessibilityIdentifier("TaskBodyTextEditor")
            
            HStack {
                Text("Completed")
                    .font(.headline)
                Spacer()
                Toggle("", isOn: $task.isCompleted)
                    .labelsHidden()
                    .accessibilityIdentifier("TaskCompletedToggle")
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
        .navigationBarTitle("Task Details", displayMode: .inline)
        .navigationBarItems(trailing: Button("Save") {
            saveTask()
        })
    }

    private func saveTask() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private extension Optional where Wrapped == String {
    var bound: String {
        get { self ?? "" }
        set { self = newValue }
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let newItem = TaskItem(context: context)
        newItem.timestamp = Date()
        newItem.title = "Sample Task"
        newItem.body = "This is a sample task description."
        newItem.isCompleted = false
        return NavigationView {
            TaskDetailView(task: newItem)
                .environment(\.managedObjectContext, context)
        }
    }
}
