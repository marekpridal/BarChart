//
//  Array+Extension.swift
//
//  Created by Marek Přidal on 23/12/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import Foundation

extension Array {
    func safe(at index: Array.Index) -> Element? {
        guard index < count else { return nil }
        return self[index]
    }
}
