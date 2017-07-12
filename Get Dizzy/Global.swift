//
//  Global.swift
//  Get Dizzy
//
//  Created by Alisson L. Selistre on 12/07/17.
//  Copyright © 2017 Alisson. All rights reserved.
//

//MARK: Collision Masks
enum CollisionCategory: Int {
    case Ground = 1, Object
}

//MARK: Game Settings
let SCENARIO_RADIUS: Float = 4 // in meters
let NUMBER_OF_OBJECTS: Int = 300
let TIME_TO_FINISH: Int = 60 // in seconds
