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
    var users = [User]()
    var teacher: Teacher?
    
    init(name: String)
    {
        self.projectId = 1
        self.name = name
    }
    
    func addUser(user: User) -> [User]
    {
        self.users.append(user)
        
        return self.users
    }
    
    func addTeacher(teacher: Teacher) -> Teacher
    {
        self.teacher = teacher
        
        return teacher
    }
}
