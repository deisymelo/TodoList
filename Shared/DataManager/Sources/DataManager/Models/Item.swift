//
//  File.swift
//  
//
//  Created by Andres Rojas on 2/05/23.
//

import Foundation

public protocol Item {
    var id: String? { get }
    var title: String { get }
    var description: String { get }
    var pending: Bool { get }
}
