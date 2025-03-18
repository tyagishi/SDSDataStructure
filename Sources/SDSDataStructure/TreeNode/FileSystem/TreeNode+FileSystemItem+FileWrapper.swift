//
//  TreeNode+FileSystemItem.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/13
//  © 2024  SmallDeskSoftware
//

import Foundation
import UniformTypeIdentifiers

extension TreeNode where T == FileSystemItem {
    public var filename: String { self.value.filename }
    public var isDirectory: Bool { self.value.content.isDirectory }
    public var isTextFile: Bool { self.value.content.isTxtFile }

    public convenience init(preferredFilename: String,_ fileWrapper: FileWrapper, textFileSuffixes: [String] = []) {
        if fileWrapper.isDirectory {
            self.init(value: .init(directory: preferredFilename))
            self.fileWrapper = fileWrapper
            
            guard let childFileWrappers = fileWrapper.fileWrappers else { return }
            for key in childFileWrappers.keys {
                guard let childFileWrapper = childFileWrappers[key] else { continue }
                let childNode = TreeNode.init(preferredFilename: key, childFileWrapper)
                addChildwithFileWrapper(childNode)
            }
            return
        }
        let content = FileSystemItem(filename: preferredFilename, fileWrapper: fileWrapper, textFileSuffixes: textFileSuffixes)
        self.init(value: content)
        self.fileWrapper = fileWrapper
        return
    }
    
    public convenience init(preferredFilename: String,_ fileWrapper: FileWrapper) {
        guard fileWrapper.isDirectory else { fatalError("Not a directory") }
        self.init(value: .init(directory: preferredFilename))
        self.fileWrapper = fileWrapper
    }
    
    public convenience init(preferredFilename: String,_ fileWrapper: FileWrapper, itemContentProvider: ItemContentProvider? = nil) {
        if fileWrapper.isDirectory {
            self.init(value: .init(directory: preferredFilename))
            self.fileWrapper = fileWrapper
            
            guard let childFileWrappers = fileWrapper.fileWrappers else { return }
            for key in childFileWrappers.keys {
                guard let childFileWrapper = childFileWrappers[key] else { continue }
                let childNode = TreeNode.init(preferredFilename: key, childFileWrapper, itemContentProvider: itemContentProvider)
                addChildwithFileWrapper(childNode)
            }
        } else if let (ownFileItem, ownFileWrapper) = itemContentProvider?(preferredFilename, fileWrapper) {
            self.init(value: ownFileItem)
            parent?.fileWrapper.removeFileWrapper(fileWrapper)
            self.fileWrapper = ownFileWrapper
        } else if let textContent = FileSystemItem.FileContent.textContent(filename: preferredFilename, fileWrapper: fileWrapper) {
            self.init(value: FileSystemItem(filename: preferredFilename, content: textContent))
            self.fileWrapper = fileWrapper
        } else if let fileData = fileWrapper.regularFileContents {
            self.init(value: FileSystemItem.init(filename: preferredFilename, data: fileData))
            self.fileWrapper = fileWrapper
        } else { fatalError("unknown")}
    }
    
    public typealias ItemContentProvider = ((String, FileWrapper) -> (FileSystemItem, FileWrapper)? )

    // take care of children only (not myself)
    public func setupTreeAlongFileWrappers( itemContentProvider: ItemContentProvider? = nil) {
        guard fileWrapper.isDirectory else { return }

        guard let childFileWrappers = fileWrapper.fileWrappers else { return }
        for key in childFileWrappers.keys {
            guard let childFileWrapper = childFileWrappers[key] else { continue }
            let childNode = TreeNode.init(preferredFilename: key, childFileWrapper, itemContentProvider: itemContentProvider)
            if childFileWrapper != childNode.fileWrapper {
                fileWrapper.removeFileWrapper(childFileWrapper)
            }
            addChildwithFileWrapper(childNode)
        }
    }
    
    public var fileWrapper: FileWrapper {
        get {
            guard let fileWrapper = dic["FileWrapper"] as? FileWrapper else { fatalError("FileSystemItem without FileWrapper") }
            return fileWrapper
        }
        set { self.dic["FileWrapper"] = newValue }
    }

    @discardableResult
    public func addFileSystemChild(_ childNode: TreeNode<FileSystemItem>, index: Int = -1) -> TreeNode<FileSystemItem> {
        let childFileWrapper = childNode.fileWrapper
        addChild(childNode, index: index)
        self.fileWrapper.addFileWrapper(childFileWrapper)
        return childNode
    }
    
    @discardableResult
    public func addDirectory(dirName: String, index: Int = -1) -> TreeNode<FileSystemItem> {
        let dirItem = FileSystemItem(directory: dirName)
        let dirNode = TreeNode(value: dirItem)
        dirNode.fileWrapper = FileWrapper(directoryWithFileWrappers: [:])
        dirNode.fileWrapper.preferredFilename = dirName
        addFileSystemChild(dirNode, index: index)
        return dirNode
    }

    @available(*, deprecated, message: "use addRegularFile(fileSystemItem:, index:) instead")
    @discardableResult
    public func addRegularFile(fileName: String, fileSystemItem: FileSystemItem, index: Int = -1) -> TreeNode<FileSystemItem> {
        guard let data = fileSystemItem.regularContent else { fatalError("use addDirectory for adding directory")}
        let newNode = TreeNode(value: fileSystemItem)
        newNode.fileWrapper = FileWrapper(regularFileWithContents: data)
        newNode.fileWrapper.preferredFilename = fileName
        addFileSystemChild(newNode, index: index)
        return newNode
    }

    @discardableResult
    public func addRegularFile(fileSystemItem: FileSystemItem, index: Int = -1) -> TreeNode<FileSystemItem> {
        guard let data = fileSystemItem.regularContent else { fatalError("use addDirectory for adding directory")}
        let newNode = TreeNode(value: fileSystemItem)
        newNode.fileWrapper = FileWrapper(regularFileWithContents: data)
        newNode.fileWrapper.preferredFilename = fileSystemItem.filename
        addFileSystemChild(newNode, index: index)
        return newNode
    }

    @discardableResult
    public func addTextFile(fileName: String, text: String, index: Int = -1) -> TreeNode<FileSystemItem> {
        let textItem = FileSystemItem(filename: fileName, text: text)
        let textNode = TreeNode(value: textItem)
        textNode.fileWrapper = FileWrapper(regularFileWithContents: text.data(using: .utf8)!)
        textNode.fileWrapper.preferredFilename = fileName
        addFileSystemChild(textNode, index: index)
        return textNode
    }

    @available(iOS 16, macOS 13, *)
    @discardableResult
    public func addPathDirectFile(fileName: String, path: URL?, fileWrapper: FileWrapper, index: Int = -1) -> TreeNode<FileSystemItem> {
        let item = FileSystemItem(pathFilename: fileName)
        let node = TreeNode(value: item)
        node.fileWrapper = fileWrapper
        node.fileWrapper.preferredFilename = fileName
        addFileSystemChild(node, index: index)
        return node
    }
    
    public func renameWithFileWrapper(to newName: String) {
        guard let oldName = self.fileWrapper.preferredFilename,
              oldName != newName else { return } // no need to change
        if isDirectory { // rename folder
            let newFileWrapper = FileWrapper(directoryWithFileWrappers: fileWrapper.fileWrappers ?? [:])
            newFileWrapper.preferredFilename = newName
            
            if let parent = self.parent {
                parent.fileWrapper.removeFileWrapper(self.fileWrapper)
                parent.fileWrapper.addFileWrapper(newFileWrapper)
            }
            if let fileWrappers = fileWrapper.fileWrappers?.values {
                fileWrappers.forEach({
                    fileWrapper.removeFileWrapper($0)
                })
            }
            self.value.filename = newName
            self.fileWrapper = newFileWrapper
        } else if let regularContent = self.value.regularContent {
            // replace fileWrapper in parent.fileWrapper.fileWrappers atKey: oldFileName
            let newFileWrapper = FileWrapper(regularFileWithContents: regularContent)
            newFileWrapper.preferredFilename = newName

            // care parent
            if let parent = self.parent {
                parent.fileWrapper.removeFileWrapper(self.fileWrapper)
                parent.fileWrapper.addFileWrapper(newFileWrapper)
            }
            self.value.filename = newName
        } else {
            fatalError("unknown node")
        }
        
        return
    }
    
    public func updateFileWrapper() {
        switch self.value.content {
        case .directory:
            for child in children {
                child.updateFileWrapper()
            }
        case .txtFile(_, let data):
            if let fwData = self.fileWrapper.regularFileContents,
               data != fwData {
                let fileWrapper = FileWrapper(regularFileWithContents: data)
                fileWrapper.preferredFilename = self.value.filename
                replaceFileWrapper(fileWrapper)
            }
        case .binFile(let data):
            if let fwData = self.fileWrapper.regularFileContents,
               data != fwData {
                let fileWrapper = FileWrapper(regularFileWithContents: data)
                fileWrapper.preferredFilename = self.value.filename
                replaceFileWrapper(fileWrapper)
            }
        case .pathDirectFile:
            // nothing needed
            break
        }
    }
    
    public func updatePathDirectFile(with url: URL) {
        if let urlFileWrapper = fileWrapper as? URLFileWrapper {
            urlFileWrapper.readPathdirectFile(from: url)
        }
        for child in self.children {
            if #available(iOS 16, macOS 13, *) {
                let refPath = url.appending(path: child.filename)
                child.updatePathDirectFile(with: refPath)
            } else {
                let refPath = url.appendingPathComponent(child.filename)
                child.updatePathDirectFile(with: refPath)
            }
        }
    }
    
    public func addChildwithFileWrapper(_ node: TreeNode<T>, index: Int = -1) {
        addChild(node, index: index)
        self.fileWrapper.addFileWrapper(node.fileWrapper)
    }

    public func removeChildwithFileWrapper(_ node: TreeNode<T>) {
        removeChild(node)
        self.fileWrapper.removeFileWrapper(node.fileWrapper)
    }

    public func replaceFileWrapper(_ newFileWapper: FileWrapper) {
        if let parent = self.parent?.fileWrapper {
            parent.removeFileWrapper(self.fileWrapper)
            parent.addFileWrapper(newFileWapper)
        }
        self.fileWrapper = newFileWapper
    }
}

public protocol URLFileWrapper: FileWrapper {
    func readPathdirectFile(from path: URL)
}
//// default empty implementation
//extension URLFileWrapper {
//    func readPathdirectFile(with path: URL) {}
//}

// for save
extension FileSystemItem {
    public func snapshot(contentType: UTType) throws -> FileSystemItem {
        switch content {
        case .binFile(let data):
            return FileSystemItem(filename: self.filename, data: data)
        case .directory:
            return FileSystemItem(directory: self.filename)
        case .txtFile(let text, _):
            return FileSystemItem(filename: self.filename, text: text)
        case .pathDirectFile:
            return FileSystemItem(pathFilename: self.filename)
        }
    }
}

extension TreeNode where T == FileSystemItem {
    public func snapshot(contentType: UTType) throws -> TreeNode<FileSystemItem> {
        let mySnapshotNode = try TreeNode<FileSystemItem>(value: self.value.snapshot(contentType: contentType))
        mySnapshotNode.fileWrapper = self.fileWrapper
        
        for child in self.children {
            let childSnapshot = try child.snapshot(contentType: contentType)
            mySnapshotNode.addFileSystemChild(childSnapshot)
        }
        return mySnapshotNode
    }
}
