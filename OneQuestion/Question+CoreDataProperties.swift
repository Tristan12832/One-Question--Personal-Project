//
//  Question+CoreDataProperties.swift
//  OneQuestion
//
//  Created by Tristan Stenuit on 11/07/2023.
//
//

import Foundation
import CoreData


extension Question {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question")
    }

    @NSManaged public var title: String
    @NSManaged public var options:  [String]
    @NSManaged public var correctOption: Int16
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isWin: Bool

}

extension Question : Identifiable {

}
