//
//  Project.swift
//  SAM
//
//  Created by Bas on 12/12/2014.
//  Copyright (c) 2014 Bas. All rights reserved.
//

import UIKit

public class Project
{
    public var id: Int
    public var name: String
    public var students = [Student]()
    public var teacher: Teacher?
    
    public init(name: String)
    {
        self.id = 1
        self.name = name
    }
    
    public func addUser(student: Student) -> [Student]
    {
        self.students.append(student)
        
        return self.students
    }
    
    public func addTeacher(teacher: Teacher) -> Teacher
    {
        self.teacher = teacher
        
        return teacher
    }
	
	public func userCount() -> Int
	{
		var amount = 0
		
		for student in self.students
		{
			amount++
		}
		
		if let teacher = self.teacher
		{
			amount++
		}
		
		return amount
	}
}
