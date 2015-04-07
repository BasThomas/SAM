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
	public var surName: String
    public var lastName: String
	
	public var fullName: String
	
	public var grade: Int?
    
	public init(_ surName: String, lastName: String)
    {
        self.surName = surName
		self.lastName = lastName
		
		self.fullName = " ".join([surName, lastName])
    }
	
	public convenience init(_ surName: String)
	{
		self.init(surName, lastName: "")
	}
}
