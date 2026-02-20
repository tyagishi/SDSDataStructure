//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2023/06/18
//  © 2023  SmallDeskSoftware
//

import Foundation

// swiftlint:disable identifier_name
public struct Index2D<Element>: Hashable where Element: Hashable {
    public let x: Element
    public let y: Element
    
    public init(_ x: Element,_ y: Element) {
        self.x = x
        self.y = y
    }
}
extension Index2D: Sendable where Element: Sendable {}

extension Index2D where Element == Int {
    public static let zero: Index2D = Index2D(0, 0)

    public static let diff8: [Diff2D<Element>] = [Diff2D(-1, -1), Diff2D(0,-1), Diff2D(1,-1),
                                           Diff2D(-1, 0), Diff2D(1, 0),
                                           Diff2D(-1, 1), Diff2D(0, 1), Diff2D(1, 1)]

    public var dir8: [Index2D] { return [self.n, self.e, self.s, self.w, self.nw, self.ne, self.se, self.sw] }

    public var n: Index2D { return Index2D(self.x    , self.y - 1) }
    public var e: Index2D { return Index2D(self.x + 1, self.y    ) }
    public var s: Index2D { return Index2D(self.x    , self.y + 1) }
    public var w: Index2D { return Index2D(self.x - 1, self.y    ) }

    public var nw: Index2D { return Index2D(self.x - 1, self.y - 1) }
    public var ne: Index2D { return Index2D(self.x + 1, self.y - 1) }
    public var se: Index2D { return Index2D(self.x + 1, self.y + 1) }
    public var sw: Index2D { return Index2D(self.x - 1, self.y + 1) }

    public func n(_ offset: Int = 1) -> Index2D { return Index2D(self.x         , self.y - offset) }
    public func e(_ offset: Int = 1) -> Index2D { return Index2D(self.x + offset, self.y         ) }
    public func s(_ offset: Int = 1) -> Index2D { return Index2D(self.x         , self.y + offset) }
    public func w(_ offset: Int = 1) -> Index2D { return Index2D(self.x - offset, self.y         ) }

    public func nw(_ offset: Int = 1) -> Index2D { return Index2D(self.x - offset, self.y - offset) }
    public func ne(_ offset: Int = 1) -> Index2D { return Index2D(self.x + offset, self.y - offset) }
    public func se(_ offset: Int = 1) -> Index2D { return Index2D(self.x + offset, self.y + offset) }
    public func sw(_ offset: Int = 1) -> Index2D { return Index2D(self.x - offset, self.y + offset) }
}

public typealias Diff2D = Index2D
public typealias Pos2D = Index2D
// swiftlint:enable identifier_name
