// Artwork depicting dimming neon-esque lights.

import SwiftUI
import CoreMotion

class IlluminationData: ObservableObject {
    @Published var illuminated = true
}

struct IlluminationView: View {
    @ObservedObject var data: IlluminationData
    
    let resolvedSystemTeal = UIColor.systemTeal.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
    let resolvedSystemYellow = UIColor.systemYellow.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
    
    var body: some View {
        ZStack() {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .foregroundColor(Color(white: 0.17))
            HStack(spacing: 72) {
                Image(systemName: "tv.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .colorMultiply(data.illuminated ? Color(resolvedSystemTeal) : .gray)
                    .shadow(color: data.illuminated ? Color(resolvedSystemTeal) : .clear, radius: 30)
                    .offset(y: 2)
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .colorMultiply(data.illuminated ? Color(resolvedSystemYellow) : .gray)
                    .shadow(color: data.illuminated ? Color(resolvedSystemYellow) : .clear, radius: 30)
            }
        }
    }
}
