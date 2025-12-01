import SwiftUI

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

@main
struct LaunchpadGlassApp: App {
    @State private var apps: [AppInfo] = Self.loadApps()
    @State private var selectedCategory: String = "All"
    @State private var showSettings = false

    var filteredApps: [AppInfo] {
        if selectedCategory == "All" {
            return apps
        } else {
            return apps.filter { $0.category == selectedCategory }
        }
    }

    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .topTrailing) {
                WindowAccessor() // <- Enables fullscreen frameless behavior
                PagedGridView(pages: filteredApps.chunked(into: 35))
                    .frame(minWidth: 800, minHeight: 600)
                    .ignoresSafeArea()
                    .sheet(isPresented: $showSettings) {
                        SettingsView {
                            showSettings = false
                        }
                    }
                }
        }
        .windowStyle(.hiddenTitleBar)

        // Add this to show "Settings…" in the app menu with ⌘,
        .commands {
            CommandGroup(replacing: .appSettings) {
                Button("Settings…") {
                    showSettings = true
                }
                .keyboardShortcut(",", modifiers: [.command])
            }
        }
    }

    static func loadApps() -> [AppInfo] {
        let appPaths = ["/Applications", "/System/Applications"]
        var foundApps: [AppInfo] = []

        for basePath in appPaths {
            guard let contents = try? FileManager.default.contentsOfDirectory(atPath: basePath) else { continue }

            for item in contents where item.hasSuffix(".app") {
                let fullPath = basePath + "/" + item
                let appName = item.replacingOccurrences(of: ".app", with: "")
                let icon = NSWorkspace.shared.icon(forFile: fullPath)
                icon.size = NSSize(width: 64, height: 64)
                let category = Self.categorizeApp(name: appName)
                foundApps.append(AppInfo(name: appName, icon: icon, path: fullPath, category: category))
            }
        }

        return foundApps.sorted { $0.name.lowercased() < $1.name.lowercased() }
    }

    static func categorizeApp(name: String) -> String {
        let categories: [String: String] = [
            "Safari": "Internet",
            "Mail": "Internet",
            "FaceTime": "Internet",
            "Terminal": "Utilities",
            "System Settings": "System",
            "Preview": "Utilities",
            "Photos": "Creative",
            "GarageBand": "Creative",
            "Final Cut Pro": "Creative"
        ]
        return categories[name] ?? "Utilities"
    }
}

struct AppInfo: Identifiable {
    let id = UUID()
    let name: String
    let icon: NSImage
    let path: String
    let category: String
}
