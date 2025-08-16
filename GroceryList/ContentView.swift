//
//  ContentView.swift
//  GroceryList
//
//  Created by Josue Lubaki on 2025-08-16.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items : [Item]
    
    @State private var item : String = ""
    
    @FocusState private var isFocused: Bool
    
    func addEssentialFoods() {
        modelContext.insert(Item(title : "Milk", isCompleted : false))
        modelContext.insert(Item(title : "Paper", isCompleted : true))
        modelContext.insert(Item(title : "Bean", isCompleted : true))
        modelContext.insert(Item(title : "Coffee", isCompleted : true))
        modelContext.insert(Item(title : "Juice", isCompleted : false))
        modelContext.insert(Item(title : "Sugar", isCompleted : true))
    }
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    Text(item.title)
                        .font(.title.weight(.light))
                        .padding(.vertical, 2)
                        .foregroundStyle(!item.isCompleted ? Color.primary : Color.accentColor)
                        .strikethrough(item.isCompleted)
                        .italic(item.isCompleted)
                        .swipeActions {
                            Button(role: .destructive) {
                                withAnimation {
                                    modelContext.delete(item)
                                }
                            } label : {
                                Label("Delete", systemImage : "trash")
                            }
                            Image(systemName: "trash")
                        }
                        .swipeActions(edge: .leading){
                            Button("Done", systemImage : item.isCompleted ? "checkmark.circle" : "x.circle"){
                                item.isCompleted.toggle()
                            }
                            .tint(!item.isCompleted ? .green : .accentColor)
                        }
                }
            }
            .navigationTitle("Grocery List")
            .toolbar {
                
                if items.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            addEssentialFoods()
                        } label : {
                            Label("Essentials", systemImage: "carrot")
                        }
                    }
                }
            }
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView(
                        "Empty List",
                        systemImage: "heart.circle",
                        description: Text("No wishes yet. Add one to get started!")
                    )
                }
            }
            .safeAreaInset(edge : .bottom){
                VStack(spacing : 12) {
                    TextField("", text: $item)
                        .textFieldStyle(.plain)
                        .padding(12)
                        .background(.tertiary)
                        .cornerRadius(12)
                        .font(.title.weight(.light))
                        .focused($isFocused)
                    
                    Button {
                        
                        guard !item.isEmpty else { return }
                        
                        let newItem = Item(title: item)
                        modelContext.insert(newItem)
                        item = ""
                        isFocused = false
                    } label : {
                        Text("Save")
                            .font(.title2.weight(.medium))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle)
                    .controlSize(.extraLarge)
                    
                }
                .padding()
                .background(.bar)
            }
        } //: NAVIGATION
    }
}

#Preview("Preview With Data") {
    let container = try! ModelContainer(for : Item.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let sampleData: [Item] = [
        Item(title : "Milk", isCompleted : false),
        Item(title : "Paper", isCompleted : true),
        Item(title : "Bean", isCompleted : true),
        Item(title : "Coffee", isCompleted : true),
        Item(title : "Juice", isCompleted : false),
        Item(title : "Sugar", isCompleted : true),
    ]
    
    for item in sampleData {
        try! container.mainContext.insert(item)
    }
    
    return ContentView().modelContainer(container)
}

#Preview("Empty data") {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
