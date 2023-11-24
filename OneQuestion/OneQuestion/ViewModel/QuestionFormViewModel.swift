//
//  QuestionFormViewModel.swift
//  OneQuestion
//
//  Created by Tristan Stenuit on 11/07/2023.
//

import Foundation
import Combine
import UIKit

class QuestionFormViewModel: ObservableObject {
    
    // Input
    @Published var title: String = ""
    @Published var options: [String] = ["", "", ""]
    @Published var correctOption: Int16 = 0
    
    init(question: Question? = nil) {
        
        if let question = question {
            self.title = question.title
            self.options = question.options
            self.correctOption = Int16(question.correctOption)
        }
        
    }
}

