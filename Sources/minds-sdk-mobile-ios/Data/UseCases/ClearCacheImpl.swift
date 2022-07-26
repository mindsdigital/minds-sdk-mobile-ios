//
//  File.swift
//  
//
//  Created by Divino Borges on 25/07/22.
//

import Foundation

struct ClearCacheImpl : ClearCache {
    func execute(url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("File could not be deleted!")
        }
    }
}

