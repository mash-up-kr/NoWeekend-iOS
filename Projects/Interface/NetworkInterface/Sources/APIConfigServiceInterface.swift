//
//  APIConfigServiceInterface.swift
//  NetworkInterface
//
//  Created by SiJongKim on 6/13/25.
//

import Foundation

public protocol APIConfigServiceInterface {
    var serverBaseURL: String { get }
    var googleBaseURL: String { get }
    
    func serverURL(for endpoint: String, pathParams: [String: String]) -> String
    func googleURL(for endpoint: String) -> String
}
