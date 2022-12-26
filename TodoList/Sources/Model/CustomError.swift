//
//  CustomError.swift
//  TodoList
//
//  Created by Deisy Melo on 26/12/22.
//

import Foundation

enum CustomError: Error {
    case notFound
    case unexpected(description: String)
}
