//
//  String+Extension.swift
//  XCOrnamentInventory
//
//  Created by Brenda Saavedra Cantu on 07/09/23.
//

import Foundation

extension String: Error, LocalizedError {
    
    public var errorDescription: String? { self }
}
