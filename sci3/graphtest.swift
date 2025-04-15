import SwiftUI
import Charts

class raphViewModel: ObservableObject {
    @Published var dataPoints: [CGPoint] = [];

    @Published var currentTime: TimeInterval = 0 // 记录当前时间
        
        func addDataPoint() {
            currentTime += 1 // 每次增加1秒
            let randomY = CGFloat.random(in: 0...100)
            dataPoints.append(CGPoint(x: CGFloat(currentTime)*10, y: 16*sin(currentTime)+60))
            objectWillChange.send()
        }
}

struct graphtest: View {
    @StateObject private var viewModel = raphViewModel()
    @State private var auxtxt: String = "";
    
    
    var body: some View {
        
        ScrollView(.horizontal) {
            VStack{
                GeometryReader { geometry in

                        Path { path in
                            if let firstPoint = viewModel.dataPoints.first {
                                path.move(to: CGPoint(x: firstPoint.x, y: geometry.size.height))
                                for point in viewModel.dataPoints.dropFirst() {
                                    path.addLine(to: CGPoint(x: point.x, y: geometry.size.height - point.y))
                                }
                            }
                        }
                        .stroke(Color.white, lineWidth: 2)

                }
                
                Text(auxtxt)
                    .onAppear {
                        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                            auxtxt += "A" // 每秒追加一个字符
                        }
                        // 在视图消失时停止计时器，以避免内存泄漏
                        RunLoop.current.add(timer, forMode: .common)
                    }
                    .foregroundColor(Color("DarkColor"));
                
            }

            
        }
            .padding(20) // Add padding for the frame
            .onAppear {
                let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    viewModel.addDataPoint()
                }
                RunLoop.current.add(timer, forMode: .common)
            }
            .frame(width: UIScreen.main.bounds.width/1.15, height: 175, alignment:.topTrailing)
            .border(Color("LightColor"), width: 1.5) // Add a black border around the frame
            .background(Color("DarkColor")) // Set a gray background color with 20% opacity
            .cornerRadius(15)

        }
}

struct GraphTest_Previews: PreviewProvider {
    static var previews: some View {
        graphtest();
    }
}


