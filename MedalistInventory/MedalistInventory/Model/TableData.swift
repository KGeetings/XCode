//
//  TableData.swift
//  Medalist
//
//  Created by Kenyon on 4/19/23.
//

import Foundation

struct TableData: Codable, Identifiable {
    var id: Int
    var material: String
    var thickness: String
    var length: Double
    var width: Double
    var quantity: Int
    var allocated: Int
}