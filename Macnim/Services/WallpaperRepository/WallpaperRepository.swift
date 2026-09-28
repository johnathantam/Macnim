//
//  WallpaperLibrary.swift
//  Macnim
//
//  Created by Johnathan Tam on 2026-09-17.
//

import Foundation
import Observation

struct WallpaperRepositoryError: LocalizedError {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    var errorDescription: String? {
        message
    }
}

@Observable
final class WallpaperRepository {
    private let wallpaperRepositoryStorageDirectory: URL
    private let wallpaperRepositoryVideosDirectory: URL
    private let wallpaperRepositoryItemsFile: URL
    private let wallpaperRepositoryItemDisplaysFile: URL
    
    // List of wallpaper items stored
    private var wallpaperItems: [WallpaperItem] = []
    // List of currently displayed wallpapers
    private var wallpaperItemDisplays: [WallpaperItemDisplay] = []

    init() throws {
        // Resolve ~/Library/Application Support
        let appSupport = FileManager.default.urls( for: .applicationSupportDirectory, in: .userDomainMask)[0]
        
        // Resolve ~/Library/Application Support/Macnim/Wallpapers
        self.wallpaperRepositoryStorageDirectory = appSupport
            .appendingPathComponent("Macnim", isDirectory: true)
            .appendingPathComponent("Wallpapers", isDirectory: true)
        
        // Resolve ~/Library/Application Support/Macnim/Wallpapers/walllpaperItems.json
        self.wallpaperRepositoryItemsFile = wallpaperRepositoryStorageDirectory.appendingPathComponent("wallpaperItems.json")
        
        self.wallpaperRepositoryItemDisplaysFile = wallpaperRepositoryStorageDirectory.appendingPathComponent("wallpaperItemDisplays.json")
        
        // Resolve ~/Library/Application Support/Macnim/Wallpapers/WallpaperVideos
        self.wallpaperRepositoryVideosDirectory = wallpaperRepositoryStorageDirectory.appendingPathComponent("WallpaperVideos", isDirectory: true)
        
        // Check whether this is the first repository startup
        let isRepositoryStorageInitialized = isRepositoryStorageInitialized()
        
        // Make sure all repository storage exists
        try initializeRepositoryStorage()
        
        // Load existing wallpapers
        self.wallpaperItems = try loadRepositoryItems()
        
        // Load existing displays
        self.wallpaperItemDisplays = try loadRepositoryItemDisplays()
        
        // Add bundled wallpapers on first startup
        if isRepositoryStorageInitialized == false {
            try loadDefaultRepositoryItems()
        }
    }
    
    private func isRepositoryStorageInitialized() -> Bool {
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: wallpaperRepositoryStorageDirectory.path) {
            return false
        }
        
        return true
    }
    
    private func initializeRepositoryStorage() throws {
        let fileManager = FileManager.default

        // Create the storage directory if it doesn't exist.
        if !fileManager.fileExists(atPath: wallpaperRepositoryStorageDirectory.path) {
            do {
                try fileManager.createDirectory(
                    at: wallpaperRepositoryStorageDirectory,
                    withIntermediateDirectories: true
                )
            } catch {
                throw WallpaperRepositoryError("Failed to create wallpaper storage directory.")
            }
        }
        
        // Create the wallpaper items file if it doesn't exist.
        if !fileManager.fileExists( atPath: wallpaperRepositoryItemsFile.path ) {
            do {
                let data = try JSONEncoder().encode([WallpaperItem]())
                try data.write(
                    to: wallpaperRepositoryItemsFile,
                    options: .atomic
                )
            } catch {
                throw WallpaperRepositoryError("Failed to create wallpaper index file.")
            }
        }
        
        // Create the wallpaper display assignments file if it doesn't exist.
        if !fileManager.fileExists(
            atPath: wallpaperRepositoryItemDisplaysFile.path
        ) {
            do {
                let data = try JSONEncoder().encode(
                    [WallpaperItemDisplay]()
                )

                try data.write(
                    to: wallpaperRepositoryItemDisplaysFile,
                    options: .atomic
                )
            } catch {
                throw WallpaperRepositoryError(
                    "Failed to create wallpaper display assignments file."
                )
            }
        }

        // Create wallpaper Videos directory
        if !fileManager.fileExists(
            atPath: wallpaperRepositoryVideosDirectory.path
        ) {
            do {
                try fileManager.createDirectory(
                    at: wallpaperRepositoryVideosDirectory,
                    withIntermediateDirectories: true
                )
            } catch {
                throw WallpaperRepositoryError("Failed to create wallpavper video directory.")
            }
        }
    }
    
    private func loadRepositoryItems() throws -> [WallpaperItem] {
        do {
            let data = try Data( contentsOf: wallpaperRepositoryItemsFile )
            return try JSONDecoder().decode(
                [WallpaperItem].self,
                from: data
            )
        } catch {
            throw WallpaperRepositoryError("Could not load repository items.")
        }
    }
    
    private func saveRepositoryItems() throws {
        do {
            let data = try JSONEncoder().encode(wallpaperItems)

            try data.write(
                to: wallpaperRepositoryItemsFile,
                options: .atomic
            )
        } catch {
            throw WallpaperRepositoryError("Could not save repository items")
        }
    }
    
    private func loadDefaultRepositoryItems() throws {
        let defaultWallpapers = [
            (wallpaperName: "Cat Train", wallpaperVideoName: "cat-train-wallpaper"),
            (wallpaperName: "Flowers in Darkness", wallpaperVideoName: "flowers-in-darkness-wallpaper"),
            (wallpaperName: "Painting Sharks", wallpaperVideoName: "painting-sharks-wallpaper"),
            (wallpaperName: "Purple Sky", wallpaperVideoName: "purple-sky-wallpaper"),
            (wallpaperName: "Red Eye", wallpaperVideoName: "red-eye-wallpaper"),
            (wallpaperName: "White Streaks", wallpaperVideoName: "white-streaks-wallpaper")
        ]
        
        for defaultWallpaper in defaultWallpapers {
                guard let wallpaperVideoURL = Bundle.main.url(
                    forResource: defaultWallpaper.wallpaperVideoName,
                    withExtension: "mp4"
                ) else {
                    throw WallpaperRepositoryError(
                        "Could not find preset wallpaper: \(defaultWallpaper.wallpaperName)"
                    )
                }

                let wallpaperItem = WallpaperItem(
                    id: UUID(),
                    name: defaultWallpaper.wallpaperName,
                    videoURL: wallpaperVideoURL
                )

                try addWallpaperItem(wallpaperItem: wallpaperItem)
            }
    }
    
    private func loadRepositoryItemDisplays() throws -> [WallpaperItemDisplay] {
        do {
            let data = try Data(
                contentsOf: wallpaperRepositoryItemDisplaysFile
            )

            return try JSONDecoder().decode(
                [WallpaperItemDisplay].self,
                from: data
            )
        } catch {
            throw WallpaperRepositoryError(
                "Could not load wallpaper display assignments."
            )
        }
    }
    
    private func saveRepositoryItemDisplays() throws {
        do {
            let data = try JSONEncoder().encode(
                wallpaperItemDisplays
            )

            try data.write(
                to: wallpaperRepositoryItemDisplaysFile,
                options: .atomic
            )
        } catch {
            throw WallpaperRepositoryError(
                "Could not save wallpaper display assignments."
            )
        }
    }
    
    public func getWallpaperItems() -> [WallpaperItem] {
        return wallpaperItems
    }
    
    public func getWallpaperItemDisplays() -> [WallpaperItemDisplay] {
        return wallpaperItemDisplays
    }
    
    public func addWallpaperItem(wallpaperItem: WallpaperItem) throws {
        let fileManager = FileManager.default
        
        let sourceURL = wallpaperItem.videoURL
        let destinationURL = wallpaperRepositoryVideosDirectory.appendingPathComponent("\(wallpaperItem.id.uuidString).mp4")
        do {
            try fileManager.copyItem( at: sourceURL, to: destinationURL )
        } catch {
            throw WallpaperRepositoryError("Could not copy video.")
        }

        var storedWallpaperItem = wallpaperItem
        storedWallpaperItem.videoURL = destinationURL
        wallpaperItems.append(storedWallpaperItem)

        try saveRepositoryItems()
    }
    
    public func removeWallpaperItem(wallpaperItemId: UUID) throws {
        guard let index = wallpaperItems.firstIndex(where: {
            $0.id == wallpaperItemId
        }) else {
            throw WallpaperRepositoryError("Wallpaper not found.")
        }
        
        // Fetch the wallpaper
        let wallpaperItem = wallpaperItems[index]
        
        // Delete the video associated with the wallpaper
        do {
            try FileManager.default.removeItem(at: wallpaperItem.videoURL)
        } catch {
            throw WallpaperRepositoryError("Could not remove video.")
        }
        
        // Remove teh wallpaper
        wallpaperItems.remove(at: index)

        try saveRepositoryItems()
    }
    
    public func editWallpaperItem(newWallpaperItem: WallpaperItem) throws {
        guard let index = wallpaperItems.firstIndex(where: {
            $0.id == newWallpaperItem.id
        }) else {
            throw WallpaperRepositoryError("Wallpaper not found.")
        }

        wallpaperItems[index] = newWallpaperItem

        try saveRepositoryItems()
    }
    
    public func addWallpaperItemDisplay(wallpaperItemDisplay: WallpaperItemDisplay) throws {
        // Make sure this wallpaper exists
        guard wallpaperItems.contains(where: {
            $0.id == wallpaperItemDisplay.wallpaperItem.id
        }) else {
            throw WallpaperRepositoryError(
                "Wallpaper not found."
            )
        }

        // Make sure this display assignment doesn't already exist
        guard !wallpaperItemDisplays.contains(where: {
            $0.id == wallpaperItemDisplay.id
        }) else {
            throw WallpaperRepositoryError(
                "Wallpaper display assignment already exists."
            )
        }

        wallpaperItemDisplays.append(wallpaperItemDisplay)

        try saveRepositoryItemDisplays()
    }

    public func removeWallpaperItemDisplay(wallpaperItemDisplayId: UUID) throws {
        guard let index = wallpaperItemDisplays.firstIndex(where: {
            $0.id == wallpaperItemDisplayId
        }) else {
            throw WallpaperRepositoryError(
                "Wallpaper display assignment not found."
            )
        }

        wallpaperItemDisplays.remove(at: index)

        try saveRepositoryItemDisplays()
    }
    
    public func editWallpaperItemDisplay(newWallpaperItemDisplay: WallpaperItemDisplay) throws {
        // Make sure the display assignment exists
        guard let index = wallpaperItemDisplays.firstIndex(where: {
            $0.id == newWallpaperItemDisplay.id
        }) else {
            throw WallpaperRepositoryError("Wallpaper display assignment not found.")
        }

        // Make sure the wallpaper still exists
        guard wallpaperItems.contains(where: {
            $0.id == newWallpaperItemDisplay.wallpaperItem.id
        }) else {
            throw WallpaperRepositoryError("Wallpaper not found.")
        }

        // Update the display assignment
        wallpaperItemDisplays[index] = newWallpaperItemDisplay

        // Persist the change
        try saveRepositoryItemDisplays()
    }
}
