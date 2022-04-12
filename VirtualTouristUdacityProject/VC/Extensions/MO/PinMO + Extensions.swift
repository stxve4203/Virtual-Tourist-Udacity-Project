//
//  PinMO + Extensions.swift
//  Virtual-Tourist-Udacity
//
//  Created by Stefan Weiss on 11.04.22.
//

import Foundation

extension Pin {
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
