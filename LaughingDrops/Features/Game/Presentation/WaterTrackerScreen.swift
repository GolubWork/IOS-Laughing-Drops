import SwiftUI

struct WaterTrackerScreen: View {
    @EnvironmentObject var history: HistoryStore
    
    @State private var selectedAmount: Int = 250
    let availableAmounts = [100, 150, 200, 250, 300, 350, 500]
    
    var body: some View {
        NavigationView {
            ZStack {
                // 🔹 Фон растянутый на весь экран
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.container, edges: .all)
                
                VStack(spacing: 30) {
                    Spacer(minLength: 0)
                    
                    CircularProgressView(
                        progress: min(Double(history.todayML) / Double(history.dailyGoal), 1.0),
                        title: "\(history.todayML) ml",
                        subtitle: "Goal: \(history.dailyGoal) ml"
                    )
                    .frame(width: 180, height: 180)
                    .padding(.top, 20)
                    
                    Picker("Amount", selection: $selectedAmount) {
                        ForEach(availableAmounts, id: \.self) { ml in
                            Text("\(ml) ml")
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    HStack(spacing: 40) {
                        Button(action: { history.remove(amount: selectedAmount) }) {
                            ZStack {
                                Image("button")
                                    .resizable()
                                    .frame(width: 120, height: 50)
                                
                                Text("Remove")
                                    .foregroundColor(.white)
                                    .font(.headline)
                            }
                        }
                        
                        Button(action: { history.add(amount: selectedAmount) }) {
                            ZStack {
                                Image("button")
                                    .resizable()
                                    .frame(width: 120, height: 50)
                                
                                Text("Add")
                                    .foregroundColor(.white)
                                    .font(.headline)
                            }
                        }
                    }

                    AdviceView()
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }
            .navigationTitle("Water Tracker")
        }
    }
}
