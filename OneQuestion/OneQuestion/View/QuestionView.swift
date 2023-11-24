//
//  QuestionView.swift
//  OneQuestion
//
//  Created by Tristan Stenuit on 13/06/2023.
//

import SwiftUI

struct QuestionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var question: Question
    
    @State private var showingResult = false
    @State private var scoreTitle = ""
    @State private var isSelected = false
    
    @State private var showingResults = false
    
    
    func askQuestion() {
        question.options.shuffled()
        question.correctOption = 0
    }
    
    func optionTapped(option: Int) {
        if option == question.correctOption {
            scoreTitle = "Correct"
            question.isWin = true
        } else {
            scoreTitle = "Incorrect"
        }
        showingResult = true
        
        
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Quetion")
                    .font(.system(.largeTitle, weight: .bold))
                
                Text(question.title)
                    .font(.system(.title, design: .rounded))
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 200)
                    .padding()
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding()
            
            VStack(spacing: 20) {
                ForEach(question.options.indices.shuffled(), id: \.self) { index in
                    Button {
                        optionTapped(option: index)
                    } label: {
                        Text(question.options[index])
                            .font(.system(.headline, design: .rounded))
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke( Color(.systemGray4), lineWidth: 8)
                            )
                            .background(Color(.systemGray5))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                
                
            }
            .padding()
            
            Spacer(minLength: 60)
            
            Button {
                askQuestion()
                self.isSelected = false
                self.question.isWin = false
            } label: {
                Text("Reset !")
                    .font(.system(.headline, design: .rounded))
                    .frame(minWidth: 0, maxWidth: 120)
            }
            .tint(Color.purple)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 25))
            .controlSize(.large)
            
            
        }

        
        .alert(scoreTitle, isPresented: $showingResult) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your anser is \(scoreTitle)")
        }
        
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 30))
                }
            }
            
            if question.isWin {
                ToolbarItem(placement: .principal) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.green)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Your question is marked as correct.")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    question.isFavorite.toggle()
                } label: {
                    Image(systemName: question.isFavorite ? "star.fill" : "star")
                        .font(.system(size: 35))
                        .foregroundColor(question.isFavorite ? .yellow : .primary)
                        .accessibilityLabel("Favorite")
                        .accessibilityHint(question.isFavorite ? "Your question is marked as favorite." : "Your question is not marked as favorite")
                }
                
            }
        }
        .onChange(of: question) { _ in
            if self.context.hasChanges {
                try? self.context.save()
            }
        }
        .accentColor(.primary)
        
        
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            QuestionView(question: (PersistenceController.testData?.first)!)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
        .accentColor(.primary)
        
    }
}
