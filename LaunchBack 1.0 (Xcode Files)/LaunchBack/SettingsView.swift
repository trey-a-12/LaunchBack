//
//  SettingsView.swift
//  LaunchBack
//
//  Created by Thomas Aldridge II on 6/22/25.
//


import SwiftUI

struct SettingsView: View {
    var onClose: () -> Void
    @State private var selectedTab: SettingsTab = .general

    enum SettingsTab: String, CaseIterable, Identifiable {
        case general = "General"
        case advanced = "Advanced"

        var id: String { rawValue }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header with Done button
            HStack {
                Spacer()
                Button("Done") {
                    onClose()
                }
                .keyboardShortcut(.cancelAction) // Allows ESC to dismiss
                .padding(.trailing, 10)
            }
            .padding(.top, 10)

            Divider()

            // Tab picker
            Picker("Settings Tab", selection: $selectedTab) {
                ForEach(SettingsTab.allCases) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Divider()

            // Tab content
            VStack {
                switch selectedTab {
                case .general:
                    GeneralSettingsView()
                case .advanced:
                    AdvancedSettingsView()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        }
        .frame(minWidth: 400, minHeight: 300)
    }
}

struct GeneralSettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("General Settings")
                .font(.headline)
            Toggle("Enable Fancy Mode", isOn: .constant(true))
            Toggle("Launch at Login", isOn: .constant(false))
        }
        .padding()
    }
}

struct AdvancedSettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Advanced Settings")
                .font(.headline)
            Toggle("Verbose Logging", isOn: .constant(false))
            Button("Reset All Settings") {
                // Implement reset logic here
            }
        }
        .padding()
    }
}
