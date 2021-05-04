// This view displays the username and profile picture of the user.

import SwiftUI

struct ProfileView: View {
    @ObservedObject var userData: UserData
    
    var body: some View {
        HStack() {
            Spacer()
            Text(userData.username ?? "")
            ZStack() {
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundColor(Color(.systemGray4))
                Image(systemName: "person.fill")
                    .accessibility(hidden: true)
            }
        }
        .font(.system(size: fmin(UIFont.preferredFont(forTextStyle: .body).pointSize, 22)))
        .foregroundColor(Color(UIColor.label.withAlphaComponent(0.5)))
    }
}
