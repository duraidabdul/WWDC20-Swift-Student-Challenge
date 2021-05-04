// Graph depicting the last 5 days of randomly generated sleep data.

import SwiftUI

struct Day: Hashable {
    let isCurrentDate: Bool
    let daySymbol: String
    let dataHeight: CGFloat
}

class GraphData: ObservableObject {
    @Published var active = true
    @Published var sleepGoal: Int = 8
    let days: [Day]
    
    init() {
        var _days: [Day] = []
        
        let currentDate = Date()
        
        for i in (0..<6).reversed() {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: currentDate)!
            let dayOfWeek = Calendar.current.component(.weekday, from: date)
            let symbol = Calendar.current.shortWeekdaySymbols[dayOfWeek - 1]
            
            // Generate random data for sleep on each day.
            let amountOfSleep = CGFloat.random(in: (i == 0 ? 8 : 7)...8.8)
            
            // Calculate the height of the data to be displayed on the GraphView.
            let dataHeight = 92 / 3 * (amountOfSleep - 6)
            
            // Test for correct height estimate.
            //let dataHeight = CGFloat(92)
            
            _days.append(Day(isCurrentDate: i == 0,
                             daySymbol: symbol,
                             dataHeight: dataHeight))
        }
        
        days = _days
    }
}

fileprivate let kContainerPadding = EdgeInsets(top: 0, leading: 4, bottom: 8, trailing: 16)

// TODO: Use GeometryReader to accurately calculate dimensions for the graph rather than estimating them.
// TODO: Improve the layout system for lines on the graph to allow for precise layout of lines.

struct GraphView: View {
    @ObservedObject var data: GraphData
    
    var body: some View {
        ZStack() {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color(.systemGray4), lineWidth: 1 + 1 / UIScreen.main.scale)
            GraphLineGroup(mode: .underlay, data: data)
            HStack() {
                Spacer()
                ForEach(data.days, id: \.self) {
                    WeekdayEntryView(day: $0)
                }
            }.padding(kContainerPadding)
            GraphLineGroup(mode: .overlay, data: data)
        }
    }
}

struct GraphLineGroup: View {
    
    enum Mode {
        case underlay, overlay
    }
    let mode: Mode
    @ObservedObject var data: GraphData
    
    var body: some View {
        VStack() {
            ForEach((6...9).reversed(), id: \.self) {
                GraphTimeLine(time: "\($0) h", isGoal: $0 == self.data.sleepGoal)
                    .opacity($0 == self.data.sleepGoal ? (self.mode == .underlay ? 0 : 1) : (self.mode == .overlay ? 0 : 1))
            }
        }.padding(kContainerPadding)
    }
}

struct WeekdayEntryView: View {
    let day: Day
    
    var body: some View {
        VStack() {
            Spacer()
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .top, endPoint: .bottom))
                .frame(width: 20, height: day.dataHeight)
                .padding(.bottom, 0)
            Text(day.daySymbol)
                .foregroundColor(day.isCurrentDate ? .red : .secondary)
                .padding(.horizontal, 2)
                .font(.system(size: 16,
                              weight: day.isCurrentDate ? .medium : .regular,
                              design: .rounded))
        }
        .frame(width: 44)
        .padding(.horizontal, -3.5)
    }
}

struct GraphTimeLine: View {
    let time: String
    let isGoal: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Text(time)
                .frame(width: 44)
                .font(.system(size: fmin(UIFont.preferredFont(forTextStyle: .body).pointSize, 19)))
                .foregroundColor(.white)
                .colorMultiply(isGoal ? .primary : .secondary)
            if isGoal {
                Circle()
                    .foregroundColor(.primary)
                    .padding(.leading, -5)
                    .frame(width: 5, height: 5)
                    .transition(AnyTransition.opacity.combined(with: .scale(scale: 0.4)))
            }
            RoundedRectangle(cornerRadius: 0.5)
                .frame(height: 1)
                .foregroundColor(isGoal ? .primary : Color(.systemGray4))
        }
        .animation(.easeInOut(duration: 0.2))
        .frame(height: 20)
    }
}
