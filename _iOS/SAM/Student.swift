//
//  Student.swift
//  SAM
//
//  Created by Bas on 12/12/2014.
//  Copyright (c) 2014 Bas. All rights reserved.
//

import UIKit

public class Student
{
	public var code: Int
	public var surName: String
    public var lastName: String
	
	public var fullName: String
	
	public var grade: Int?
    
	public init(_ surName: String, lastName: String, code: Int)
    {
		self.code = code
        self.surName = surName
		self.lastName = lastName
		
		self.fullName = " ".join([surName, lastName])
    }
	
	public convenience init(_ surName: String, code: Int)
	{
		self.init(surName, lastName: "", code: code)
	}
}

// MARK: - Hashable
extension Student: Hashable
{
	/// The hash value.
	public var hashValue: Int
	{
		return self.code.hashValue
	}
}

public func ==(lhs: Student, rhs: Student) -> Bool
{
	return lhs.code == rhs.code
}