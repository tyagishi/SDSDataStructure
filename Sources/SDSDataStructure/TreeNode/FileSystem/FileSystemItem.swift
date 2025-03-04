//
//  FileSystemItem.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/13
//  © 2024  SmallDeskSoftware
//

import Foundation
import SDSMacros
import SDSStringExtension
import UniformTypeIdentifiers
import Combine

public enum FileSystemItemChange {
    case filenameChanged(String)
    case contentChanged(Data)
    case textChagned(String)
}

public protocol FileSystemItemProtocol {
    var dic: [String: Any] { get set }
    func snapshot(contentType: UTType) throws -> Self
}


@DidChangeObject<FileSystemItemChange>
open class FileSystemItem: Identifiable, ObservableObject { // Equatable?
    public let id = UUID()
    public var filename: String {
        didSet { self.objectDidChange.send(.filenameChanged(oldValue)) }
    }

    public typealias FileItemContentProvider = (String, FileWrapper) -> FileSystemItem.FileContent?

    @IsCheckEnum
    @AssociatedValueEnum
    public enum FileContent {
        case directory
        case txtFile(String, Data)
        case binFile(Data)
        case pathDirectFile
    }
    
    public private(set) var content: FileContent
    public var dic: [String: Any] = [:]

    public init(directory dirname: String) {
        self.content = .directory
        self.filename = dirname
    }

    public convenience init(filename: String, text: String) {
        self.init(filename: filename, content: .txtFile(text, text.data(using: .utf8)!))
    }
    
    public convenience init(filename: String, data: Data) {
        self.init(filename: filename, content: .binFile(data))
    }
    
    public convenience init(pathFilename: String) {
        self.init(filename: pathFilename, content: .pathDirectFile)
    }
    
    public init(filename: String, content: FileContent) {
        self.filename = filename
        self.content = content
    }

    // init with file type detection
    public convenience init(filename: String, fileWrapper: FileWrapper, textFileSuffixes: [String] = []) {
        guard let data = fileWrapper.regularFileContents else { fatalError("can not handle directory/symbolic link") }
        let content: FileContent = Self.textContent(filename: filename, fileWrapper: fileWrapper, textFileSuffixes: textFileSuffixes) ?? FileContent.binFile(data)
        self.init(filename: filename, content: content)
    }
    
    public static func textContent(filename: String, fileWrapper: FileWrapper, textFileSuffixes: [String] = []) -> FileContent? {
        guard let fileData = fileWrapper.regularFileContents else { return nil }
        if let subSuffix = filename.dotSuffix {
            let suffix = String(subSuffix)

            // try to check whether file can be handled as text file
            if textFileSuffixes.contains(suffix),
               let text = String(data: fileData, encoding: .utf8) {
                return FileContent.txtFile(text, fileData)
            } else if let utType = UTType(filenameExtension: suffix) {
                if utType.conforms(to: .plainText),
                   let text = String(data: fileData, encoding: .utf8) {
                    return FileContent.txtFile(text, fileData)
                }
            }
        }
        return nil
    }

    // init with contentProvider
    public convenience init?(filename: String, fileWrapper: FileWrapper,_ contentProvider: FileItemContentProvider) {
        guard let content = contentProvider(filename, fileWrapper) else { return nil }
        self.init(filename: filename, content: content)
    }
    
    public var regularContent: Data? {
        switch self.content {
        case .directory:            return nil
        case .txtFile(_, let data): return data
        case .binFile(let data):    return data
        case .pathDirectFile:       return nil
        }
    }
}

extension FileSystemItem {
    public func setText(_ newText: String) {
        self.content = .txtFile(newText, newText.data(using: .utf8)!)
        self.objectDidChange.send(.textChagned(newText))
    }
    public func setData(_ newData: Data) {
        self.content = .binFile(newData)
        self.objectDidChange.send(.contentChanged(newData))
    }
}
