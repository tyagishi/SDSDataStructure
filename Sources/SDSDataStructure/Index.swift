//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2023/06/18
//  © 2023  SmallDeskSoftware
//

import Foundation

// swiftlint:disable identifier_name
struct Index2D<Element>: Hashable where Element: Hashable {
    let x: Element
    let y: Element
    
    init(_ x: Element,_ y: Element) {
        self.x = x
        self.y = y
    }
}
extension Index2D: Sendable where Element: Sendable {}

extension Index2D where Element == Int {
    static let zero: Index2D = Index2D(0, 0)

    static let diff8: [Diff2D<Element>] = [Diff2D(-1, -1), Diff2D(0,-1), Diff2D(1,-1),
                                           Diff2D(-1, 0), Diff2D(1, 0),
                                           Diff2D(-1, 1), Diff2D(0, 1), Diff2D(1, 1)]

    var dir8: [Index2D] { return [self.n, self.e, self.s, self.w, self.nw, self.ne, self.se, self.sw] }

    var n: Index2D { return Index2D(self.x    , self.y - 1) }
    var e: Index2D { return Index2D(self.x + 1, self.y    ) }
    var s: Index2D { return Index2D(self.x    , self.y + 1) }
    var w: Index2D { return Index2D(self.x - 1, self.y    ) }

    var nw: Index2D { return Index2D(self.x - 1, self.y - 1) }
    var ne: Index2D { return Index2D(self.x + 1, self.y - 1) }
    var se: Index2D { return Index2D(self.x + 1, self.y + 1) }
    var sw: Index2D { return Index2D(self.x - 1, self.y + 1) }

    func n(_ offset: Int = 1) -> Index2D { return Index2D(self.x         , self.y - offset) }
    func e(_ offset: Int = 1) -> Index2D { return Index2D(self.x + offset, self.y         ) }
    func s(_ offset: Int = 1) -> Index2D { return Index2D(self.x         , self.y + offset) }
    func w(_ offset: Int = 1) -> Index2D { return Index2D(self.x - offset, self.y         ) }

    func nw(_ offset: Int = 1) -> Index2D { return Index2D(self.x - offset, self.y - offset) }
    func ne(_ offset: Int = 1) -> Index2D { return Index2D(self.x + offset, self.y - offset) }
    func se(_ offset: Int = 1) -> Index2D { return Index2D(self.x + offset, self.y + offset) }
    func sw(_ offset: Int = 1) -> Index2D { return Index2D(self.x - offset, self.y + offset) }
}

typealias Diff2D = Index2D
typealias Pos2D = Index2D
// swiftlint:enable identifier_name
