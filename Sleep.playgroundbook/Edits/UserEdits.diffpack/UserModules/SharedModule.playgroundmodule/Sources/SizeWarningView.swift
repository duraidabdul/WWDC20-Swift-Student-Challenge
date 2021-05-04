
import SwiftUI

struct SizeWarningView: View {
    
    @State var fadeTrigger = false
    
    var repeatingAnimation: Animation {
        Animation.easeInOut(duration: 1)
            .repeatForever()
    }
    
    var body: some View {
        HStack() {
            Spacer()
            Text("Maximize View")
            Image(systemName: "rectangle.and.arrow.up.right.and.arrow.down.left")
        }
        .font(.system(size: fmin(UIFont.preferredFont(forTextStyle: .body).pointSize, 22)))
        .foregroundColor(.gray)
        .opacity(fadeTrigger ? 0.4 : 1)
        .onAppear {
            withAnimation(self.repeatingAnimation) {
                self.fadeTrigger.toggle()
            }
        }
    }
}

