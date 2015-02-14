//
//  Project.swift
//  SAM
//
//  Created by Bas on 12/12/2014.
//  Copyright (c) 2014 Bas. All rights reserved.
//

import UIKit

class Project
{
    var projectId: Int
    var name: String
    var students = [Student]()
    var teacher: Teacher?
    
    init(name: String)
    {
        self.projectId = 1
        self.name = name
    }
    
    func addUser(student: Student) -> [Student]
    {
        self.students.append(student)
        
        return self.students
    }
    
    func addTeacher(teacher: Teacher) -> Teacher
    {
        self.teacher = teacher
        
        return teacher
    }
    
    func description() -> String
    {
        var studentString = ""
        for student in self.students
        {
            studentString += "\(student.name) "
        }
        
        return "Project: \(self.name) Teacher: \(self.teacher?.name) Students: \(studentString)"
    }
}
