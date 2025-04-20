//
//  MemoryLeakChecker.swift
//  AdvancedSwift
//
//  Created by choijunios on 4/20/25.
//

public struct MemoryLeakChecker {
    private weak var object: AnyObject?
    init(object: AnyObject) {
        self.object = object
    }
    public func isReleased() -> Bool { object == nil }
}
