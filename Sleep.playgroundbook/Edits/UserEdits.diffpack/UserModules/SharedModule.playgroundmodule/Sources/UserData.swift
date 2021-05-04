// Observable class that locally organizes information on the user's information. This information could be read from the cloud, or from a local encrypted source. For this Playground, information on a user will be randomly generated.

import Combine

public class UserData: ObservableObject {
    
    static public let shared = UserData()
    
    @Published public var username: String? = "John Appleseed"
    let graphData = GraphData()
}
