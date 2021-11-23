//
//  Constants.swift
//  CatsHome
//
//  Created by Iryna Zinko on 11/23/21.
//

import Foundation

struct PhysicsCategories{
    static let None   : UInt32 = 0
    static let Player : UInt32 = 0b1 //1 binary
    static let Bullet : UInt32 = 0b10 //2 binary
    static let Enemy   : UInt32 = 0b100 //4 binary
}
