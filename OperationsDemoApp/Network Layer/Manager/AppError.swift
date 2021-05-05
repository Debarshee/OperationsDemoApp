//
//  AppError.swift
//  MoviesInfoAppDemo
//
//  Created by Debarshee on 4/10/21.
//

import Foundation

enum AppError: Error {
    case invalidUrl
    case serverError
    case noResponse
    case noData
    case parsingError
    case badResponse
    case parseError
    case badRequest
    case genericError(String)
}
