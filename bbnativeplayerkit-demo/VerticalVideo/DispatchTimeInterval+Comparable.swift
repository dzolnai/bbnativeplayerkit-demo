//
//  DispatchTimeInterval+Comparable.swift
//  bbnativeplayerkit-demo
//
//  Created by Dániel Zolnai on 07/08/2024.
//

//
//  NSTimeInterval+Comparable.swift
//  Groei
//
//  Created by Dániel Zolnai on 2023. 06. 23..
//  Copyright © 2023. Egeniq. All rights reserved.
//

import Foundation

extension DispatchTimeInterval: Comparable {
    // swiftlint:disable identifier_name
    private var totalNanoseconds: Int64 {
        switch self {
        case .nanoseconds(let ns): return Int64(ns)
        case .microseconds(let us): return Int64(us) * 1_000
        case .milliseconds(let ms): return Int64(ms) * 1_000_000
        case .seconds(let s): return Int64(s) * 1_000_000_000
        case .never: fatalError("infinite nanoseconds")
        @unknown default: fatalError("Unknown DispatchTimeInterval value")
        }
    }
    // swiftlint:enable identifier_name
    public static func < (lhs: DispatchTimeInterval, rhs: DispatchTimeInterval) -> Bool {
        if lhs == .never { return false }
        if rhs == .never { return true }
        return lhs.totalNanoseconds < rhs.totalNanoseconds
    }
}
