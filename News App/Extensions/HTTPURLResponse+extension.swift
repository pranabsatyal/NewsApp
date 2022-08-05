//
//  HTTPURLResponse+extension.swift
//  Assignment12
//
//  Created by Pranab Raj Satyal on 7/8/21.
//

import UIKit

extension HTTPURLResponse {
    
    func isValidResponse() -> Bool {
        return (200...299).contains(self.statusCode)
    }
    
}
// some changes here
