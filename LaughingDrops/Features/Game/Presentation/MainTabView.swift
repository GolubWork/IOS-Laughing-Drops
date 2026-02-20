import SwiftUI

/// <summary>
/// Main tab view providing navigation between game application sections:
/// </summary>
struct MainTabView: View {
    @EnvironmentObject var history: HistoryStore
    
    var body: some View {
        TabView {
            WaterTrackerScreen()
                .tabItem { Image(systemName: "drop.fill"); Text("Main") }
            
            CalendarScreen()
                .tabItem { Image(systemName: "calendar"); Text("Calendar") }
            
            WaterChartScreen()
                .tabItem { Image(systemName: "chart.bar.fill"); Text("Graph") }
            
            AchievementsScreen()
                .tabItem { Image(systemName: "rosette"); Text("Achievements") }
            
            NotificationSettingsView()
                .tabItem { Image(systemName: "bell.fill"); Text("Notifications") }
        }
        .onAppear {
        }}}
