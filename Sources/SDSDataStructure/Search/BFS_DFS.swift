//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2023/06/19
//  © 2023  SmallDeskSoftware
//

import Foundation

// MARK: bfs v1.0
func bfs<Index>(_ start: Index,
                prepChild: @escaping (_ from: Index) -> [Index],
                process: @escaping (_ index: Index) -> StopKeep) {
    var processQueue = Dequeue<Index>()

    let nexts = prepChild(start)
    _ = nexts.map({ processQueue.addLast($0) })

    while let next = processQueue.popFirst() {
        if process(next) == .stop { break }
        let nextNexts = prepChild(next)
        _ = nextNexts.map({ processQueue.addLast($0) })
    }
}

// MARK: dfs v1.0
func dfs<Index>(_ start: Index,
                prepChild: @escaping (_ from: Index) -> [Index],
                process: @escaping (_ index: Index) -> StopKeep) {
    let nexts = prepChild(start)
    for next in nexts {
        if process(next) == .stop { break }
        dfs(next, prepChild: prepChild, process: process)
    }
}
