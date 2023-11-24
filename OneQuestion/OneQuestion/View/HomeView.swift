//
//  HomeView.swift
//  OneQuestion
//
//  Created by Tristan Stenuit on 06/06/2023.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) var context

    //Inserts data (questions) into the view
    @FetchRequest(
        entity: Question.entity(),
        sortDescriptors: [])
    var questions: FetchedResults<Question>
    
    //Deleted method
    private func deleteRecord(indexSet: IndexSet) {
        for index in indexSet {
            let itemToDelete = questions[index]
            context.delete(itemToDelete)
        }

        DispatchQueue.main.async {
            do {
                try context.save()

            } catch {
                print(error)
            }
        }
    }
    
    @State private var showNewQuestion = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(questions.indices, id: \.self) { index in
                    NavigationLink(destination: QuestionView(question: questions[index])) {
                        QuestionCell(question: questions[index], index: index + 1)
                    }
                }
                .onDelete(perform: deleteRecord)
                .listRowSeparator(.hidden)

            }
            .listStyle(.plain)
            .navigationTitle("OneQuestion")
            .navigationBarTitleDisplayMode(.automatic)

            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing ) {
                    Button(action: {
                        self.showNewQuestion = true
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(width: 45, height: 45)
                                .cornerRadius(8)
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                        }
                        .accessibilityLabel("Add")
                        .accessibilityHint("Add a question.")
                    }
                    .tint(Color.purple)
                }
             
            }
            .tint(.primary)
            .sheet(isPresented: $showNewQuestion) {
                NewQuestion()
            }
        }

        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct QuestionCell: View {
    
    @ObservedObject var question: Question

    @State private var showOptions = false
    @State var index = 1
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: "\(index).square")
                .font(.system(.largeTitle, design: .rounded))

            VStack(alignment: .leading) {
                Text(question.title)
                    .font(.system(.title2, design: .rounded))
                Text("Status \(question.isWin ? "successful" : "no successful")")
                    .font(.system(.body, design: .rounded))
            }
            Spacer()
            
            if question.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.system(.title2, design: .rounded))

            }
            if question.isWin {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(.title2, design: .rounded))
            }
            
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false, content: {
            Button {
                self.question.isFavorite.toggle()
            } label: {
                Image(systemName: "star.fill")
            }
            .tint(.yellow)
        })
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Question number \(index), entitled \(question.title), \(question.isWin ? "has been played and passed" : ": has not yet been played or passed."), \(question.isFavorite ? "It is marked as favourite" : "").")

    }
}
