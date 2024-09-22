//
//  Array+Extensions.swift
//  WeatherIOS
//
//  Created by Janaina A on 21/09/2024.
//

import Foundation

extension Array {
    /// Removes duplicate elements from an array based on a unique key.
    func removingDuplicates<T: Hashable>(byKey key: (Element) -> T)  -> [Element] {
        var result = [Element]()
        var seen = Set<T>()
        for value in self {
            if seen.insert(key(value)).inserted {
                result.append(value)
            }
        }
        return result
    }
}
