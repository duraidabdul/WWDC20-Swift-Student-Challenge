// Artwork depicting a starry night.

import SwiftUI
import CoreMotion

class StarryNightData: ObservableObject {
    @Published var nightFraction: Double = 1
    
    var repeatingAnimation: Animation {
        Animation.easeInOut(duration: 1.5)
            .repeatForever()
    }
    
    @Published var starBrightnessToggle = false
    @Published var starsVisible = false {
        didSet {
            withAnimation(repeatingAnimation) {
                self.starBrightnessToggle.toggle()
            }
        }
    }
    @Published var offset: CGPoint = .zero
    
    let motion = CMMotionManager()
    var timer: Timer?
    
    func startDeviceMotion() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            // Configure a timer to update motion data.
            self.timer = Timer(fire: Date(), interval: (1.0 / 60.0), repeats: true,
                               block: { _ in
                                if let data = self.motion.deviceMotion {
                                    // Use the motion data in your app.
                                    self.offset = CGPoint(x: data.attitude.pitch * 5,
                                                          y: -data.attitude.roll * 5)
                                }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.default)
        }
    }
    
    init() {
        startDeviceMotion()
    }
}

struct StarryNightView: View {
    @ObservedObject var data: StarryNightData
    
    var body: some View {
        ZStack() {
            LinearGradient(gradient: Gradient(colors: [Color(hue: 0.67, saturation: 0.6, brightness: 0.6 - 0.2 * data.nightFraction - 0.1), Color(hue: 0.67, saturation: 0.6, brightness: 0.6 - 0.2 * data.nightFraction)]), startPoint: .top, endPoint: .bottom)
                .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
                // Prevent a SwiftUI cycling animation bug that occurs when VoiceOver is enabled.
                .animation(nil)
            if data.starsVisible {
                // Highly tuned positions for star views.
                Image(uiImage: UIImage(named: "Stars-1.png") ?? UIImage())
                    .offset(x: data.offset.x * 2, y: data.offset.y * 1.5)
                    .transition(AnyTransition.scale(scale: 0.7).combined(with: .opacity))
                Image(uiImage: UIImage(named: "Stars-2.png") ?? UIImage())
                    .opacity(data.starBrightnessToggle ? 1 : 0.65)
                    .offset(x: data.offset.x * 1.66, y: data.offset.y * 1.25)
                    .transition(AnyTransition.scale(scale: 0.75).combined(with: .opacity))
                Image(uiImage: UIImage(named: "Stars-3.png") ?? UIImage())
                    .opacity(data.starBrightnessToggle ? 0.5 : 1)
                    .offset(x: data.offset.x * 1.33, y: data.offset.y)
                    .transition(AnyTransition.scale(scale: 0.8).combined(with: .opacity))
                Image(uiImage: UIImage(named: "Stars-4.png") ?? UIImage())
                    .opacity(data.starBrightnessToggle ? 0.65 : 1)
                    .offset(x: data.offset.x, y: data.offset.y * 0.75)
                    .transition(AnyTransition.scale(scale: 0.85).combined(with: .opacity))
                Image(uiImage: UIImage(named: "Stars-5.png") ?? UIImage())
                    .opacity(data.starBrightnessToggle ? 1 : 0.25)
                    .offset(x: data.offset.x * 0.66, y: data.offset.y * 0.5)
                    .transition(AnyTransition.scale(scale: 0.9).combined(with: .opacity))
        }
        }
    }
}
