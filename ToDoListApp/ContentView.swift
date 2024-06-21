import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskItem.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<TaskItem>

    @State private var newTaskTitle = ""
    @State private var isAddingTask = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(items) { item in
                        NavigationLink(destination: TaskDetailView(task: item)) {
                            HStack {
                                Text(item.title ?? "Untitled Task")
                                    .accessibilityIdentifier("TaskTitle_\(item.title ?? "Untitled")")
                                Spacer()
                                if item.isCompleted {
                                    Image(systemName: "checkmark.circle")
                                        .foregroundColor(.green)
                                        .accessibilityIdentifier("TaskCompleted_\(item.title ?? "Untitled")")
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }

                if isAddingTask {
                    HStack {
                        TextField("New Task", text: $newTaskTitle, onCommit: addItem)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .accessibilityIdentifier("NewTaskTextField")
                        Button(action: addItem) {
                            Text("Add")
                                .accessibilityIdentifier("AddButton")
                        }
                        .padding(.trailing)
                    }
                    .background(Color(UIColor.systemGroupedBackground))
                }

                Spacer()
            }
            .navigationBarTitle("To-Do List")
            .navigationBarItems(trailing: HStack {
                EditButton()
                Button(action: { isAddingTask.toggle() }) {
                    Image(systemName: "plus")
                        .accessibilityIdentifier("AddTaskButton")
                }
            })
        }
    }

    private func addItem() {
        withAnimation {
            guard !newTaskTitle.isEmpty else { return }
            let newItem = TaskItem(context: viewContext)
            newItem.timestamp = Date()
            newItem.title = newTaskTitle
            newItem.isCompleted = false

            do {
                try viewContext.save()
                newTaskTitle = ""
                isAddingTask = false
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
