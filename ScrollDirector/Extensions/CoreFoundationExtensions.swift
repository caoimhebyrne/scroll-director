//
//  CFSet.swift
//  ScrollDirector
//
//  Created by Caoimhe on 10/06/2023.
//

import Foundation
import CoreFoundation

extension CFSet {
    func toArray<T>() -> [T]? {
        let set = self as NSSet
        return set.allObjects as? [T] ?? nil
    }
}
