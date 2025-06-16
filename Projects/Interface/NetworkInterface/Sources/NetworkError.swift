//
//  NetworkError.swift
//  NetworkInterface
//
//  Created by SiJongKim on 6/13/25.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
}
