//
//  VisitChecker.swift
//  AdvancedSwift
//
//  Created by choijunios on 4/25/25.
//

public struct VisitChecker<Element: AnyObject> {
    private var container: Set<ObjectIdentifier> = .init()
    
    public init() { }
    
    public mutating func visit(_ element: Element) {
        container.insert(ObjectIdentifier(element))
    }
    
    public func isVisited(_ element: Element) -> Bool {
        let id = ObjectIdentifier(element)
        return container.contains(id)
    }
}
