import SwiftUI

struct AdviceView: View {
    private let tips = [
        "Start your day with a glass of water.",
        "Drink small amounts every 30–60 minutes.",
        "Keep a water bottle nearby.",
        "Set reminders to drink water.",
        "Drink water before each meal.",
        "Use tracking apps to monitor intake.",
        "Drink water after running or exercising.",
        "Add a slice of lemon for flavor.",
        "Drink before you feel thirsty.",
        "Keep a bottle on your desk.",
        "Use a glass or metal water bottle.",
        "Set daily glass goals.",
        "Drink water in the morning before coffee.",
        "Listen to your body when tired — it may signal thirst.",
        "Alternate water with herbal teas.",
        "Water helps keep your skin hydrated.",
        "Try to drink a glass every 1–2 hours.",
        "Use reminders on your phone or smartwatch.",
        "Check the color of your urine — light yellow is normal.",
        "Drink water if you feel a headache coming on.",
        "Start workouts with 1–2 glasses of water.",
        "Add fruits for flavor and vitamins.",
        "Drink water before bed, but in small amounts.",
        "Water improves concentration and memory."
    ]

    @State private var tip: String = ""

    var body: some View {
        Text(tip)
            .font(.body)
            .multilineTextAlignment(.center)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
            .onAppear {
                tip = tips.randomElement() ?? tips[0]
            }
    }
}
