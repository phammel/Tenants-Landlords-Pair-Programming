//
//  Global.swift
//  Pair programming
//
//  Created by Phammel on 3/10/17.
//  Copyright © 2017 Phammel. All rights reserved.
//

import Foundation

import Firebase
import UIKit

var ref: FIRDatabaseReference
{
    return FIRDatabase.database().reference()
}



func set(_ val: Any, forKey key: String)
{
    ref.updateChildValues([key:val])
}
