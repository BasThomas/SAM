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
	public var startDate: NSDate
	public var endDate: NSDate?
    public var students = [Student]()
    public var teacher: Teacher?
	
	public init(id: Int, name: String, startDate: NSDate, endDate: NSDate?)
	{
		self.id = id
		self.name = name
		
		self.startDate = startDate
		self.endDate = endDate
	}
	
	public convenience init(name: String, startDate: NSDate, endDate: NSDate?)
    {
		self.init(id: 1, name: name, startDate: startDate, endDate: endDate)
    }
	
	public convenience init(id: Int, startDate: NSDate, endDate: NSDate?)
	{
		self.init(id: id, name: "Unknown", startDate: startDate, endDate: endDate)
	}
    
    public func addStudent(student: Student) -> [Student]
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

// MARK: - Hashable
extension Project: Hashable
{
	/// The hash value.
	public var hashValue: Int
	{
		return self.id.hashValue
	}
}

public func ==(lhs: Project, rhs: Project) -> Bool
{
	return lhs.id == rhs.id
}