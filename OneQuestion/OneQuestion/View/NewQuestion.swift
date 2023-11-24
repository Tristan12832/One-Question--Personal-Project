//
//  NewQuestion.swift
//  OneQuestion V0.9
//
//  Created by Tristan Stenuit on 11/07/2023.
//

import SwiftUI

struct NewQuestion: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context

//    @State private var title = ""
//    @State private var  options = [String]()
//    @State private var  correctOption = 0
    
    
    @ObservedObject private var questionFormViewModel: QuestionFormViewModel
    init() {
        let viewModel = QuestionFormViewModel()
        questionFormViewModel = viewModel
    }
    
    
    private func save() {
        let question = Question(context: context)
        question.title = questionFormViewModel.title
        question.options = questionFormViewModel.options
        question.correctOption = questionFormViewModel.correctOption
        question.isWin = false
        question.isFavorite = false

        do {
            try context.save()
        } catch {
            print("Failed to save the record...")
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    FormTextField(label: "Title of the question", placeholder: "Write the title of your question.", value: $questionFormViewModel.title)
                    
                    VStack(alignment: .leading) {
                        Text("How to write your question")
                            .font(.title2)
                            .fontDesign(.rounded)
                            .bold()
                        Text("you write below 3 suggested answers, the first of which is the correct answer.")
                    }
                    .padding(.bottom)
                    .accessibilityElement(children: .combine)
                    
                    FormTextField(label: "Answer 1", placeholder: "Write your correct answer.", value: $questionFormViewModel.options[0])
                    
                    FormTextField(label: "Answer 2", placeholder: "Write your incorrect answer.", value: $questionFormViewModel.options[1])
                    
                    FormTextField(label: "Answer 3", placeholder: "Write your incorrect answer.", value: $questionFormViewModel.options[2])
                    
                }
                .padding()
                
            }
            .navigationTitle("New Question")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.headline)
                    }
                    
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        save()
                        dismiss()
                    } label: {
                        Text("Save")
                            .font(.headline)
                    }
                }
            }
            .accentColor(.primary)
        }
    }
    
    struct NewQuestion_Previews: PreviewProvider {
        static var previews: some View {
            NewQuestion()
                .previewDisplayName("Light")
                .preferredColorScheme(.light)
            
            NewQuestion()
                .previewDisplayName("Dark")
                .preferredColorScheme(.dark)
            
        }
    }
    
    struct FormTextField: View {
        let label: String
        var placeholder: String = ""
        
        @Binding var value: String
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(label.uppercased())
                    .font(.system(.headline, design: .rounded))
                
                TextField(placeholder, text: $value)
                    .font(.system(.body, design: .rounded))
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(.systemGray5), lineWidth: 1)
                    )
                    .padding(.vertical, 10)
                
            }
        }
    }
}
