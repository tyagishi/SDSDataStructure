//
//  ContentView.swift
//  FileViewerExample
//
//  Created by Tomoaki Yagishita on 2026/05/09.
//

import SwiftUI
import SDSDataStructure
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var rootNode: TreeNode<FileSystemItem> = TreeNode(value: FileSystemItem(directory: "root"))
    @State private var selectedItemID: TreeNode<FileSystemItem>.ID?
    @State private var showImporter = true
    var body: some View {
        VStack {
            NavigationSplitView(sidebar: {
                List(selection: $selectedItemID, content: {
                    NodeTreeView(node: rootNode)
                })
            }, detail: {
                DetailView(itemID: selectedItemID, rootNode: rootNode)
            })
        }
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [UTType.directory], onCompletion: { result in
            switch result {
            case .failure(let failure):  print(failure); return
            case .success(let url):
                guard url.startAccessingSecurityScopedResource() else { return }
                guard let rootFileWrapper = try? FileWrapper(url: url) else { return }
                rootNode = TreeNode(preferredFilename: url.lastPathComponent, rootFileWrapper)
                rootNode.setupTreeAlongFileWrappers()
                url.stopAccessingSecurityScopedResource()
            }
        })
        .padding()
    }
}

#Preview {
    ContentView()
}

struct NodeTreeView: View {
    var node: TreeNode<FileSystemItem>
    var body: some View {
        if node.isDirectory {
            DisclosureGroup(node.filename, content: {
                ForEach(node.children, id: \.self) { child in
                    NodeTreeView(node: child)
                }
            }).tag(node.id)
        } else {
            Text(node.filename).tag(node.id)
        }
    }
}

struct DetailView: View {
    let itemID: TreeNode<FileSystemItem>.ID?
    let rootNode: TreeNode<FileSystemItem>
    var body: some View {
        if let itemID = itemID,
           let node = rootNode.node(id: itemID) {
            if let text = node.value.text {
                Text(text)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            } else {
                Text("node type is not supported")
            }
        } else {
            Text("node is not selected")
        }
    }
}
