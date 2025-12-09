import SwiftUI

struct AchievementsScreen: View {
    @EnvironmentObject var history: HistoryStore

    var body: some View {
        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 10) {
                        Spacer()

                        achievementRow(title: "Reach daily goal today",
                                       achieved: history.todayML >= history.dailyGoal)

                        achievementRow(title: "Reach daily goal 7 days in a row",
                                       achieved: history.streak(days: 7))

                        achievementRow(title: "Reach daily goal 30 days in a row",
                                       achieved: history.streak(days: 30))

                        achievementRow(title: "Reach daily goal 365 days in a row",
                                       achieved: history.streak(days: 365))

                        achievementRow(title: "Drink 2 liters in a day",
                                       achieved: history.todayML >= 2000)

                        achievementRow(title: "Drink 3 liters in a day",
                                       achieved: history.todayML >= 3000)

                        achievementRow(title: "Stay hydrated 14 days in a row",
                                       achieved: history.streak(days: 14))

                        achievementRow(title: "Log water 100 times",
                                       achieved: history.history.count >= 100)

                        achievementRow(title: "Perfect week (7/7 goals)",
                                       achieved: history.perfectWeek())

                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 80)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Achievements")
        }
    }

    func achievementRow(title: String, achieved: Bool) -> some View {
        HStack {
            Image(systemName: achieved ? "checkmark.seal.fill" : "seal")
                .foregroundColor(achieved ? .green : .gray)

            Text(title)
                .foregroundColor(.blue)

            Spacer()
        }
        .padding()
        .cornerRadius(12)
    }
}
