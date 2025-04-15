//
//  Monitor.swift
//  sci3
//
//  Created by 章稼润 on 2024/6/30.
//

import SwiftUI
import Charts


protocol GraphViewModelProtocol {
    var dataPoints: [CGPoint] { get set }
    var currentTime: TimeInterval { get set }
    
    func addDataPoint()
}

class GraphViewModel: ObservableObject, GraphViewModelProtocol {
    @Published var dataPoints: [CGPoint] = [];

    @Published var currentTime: TimeInterval = 0 // 记录当前时间
    
        
        func addDataPoint() {
            currentTime += 1 // 每次增加1秒
            dataPoints.append(CGPoint(x: CGFloat(currentTime)*10, y: 16*sin(currentTime)+60))
            objectWillChange.send()
        }
}

class GraphViewModel2: ObservableObject, GraphViewModelProtocol {
    @Published var dataPoints: [CGPoint] = [];

    @Published var currentTime: TimeInterval = 0 // 记录当前时间
        
        func addDataPoint() {
            currentTime += 1 // 每次增加1秒
            dataPoints.append(CGPoint(x: CGFloat(currentTime)*10, y: 5*sin(currentTime)+90))
            objectWillChange.send()
        }
}

struct Monitor: View {
    @State private var viewModel: GraphViewModelProtocol = GraphViewModel()
    @State private var auxtxt: String = "";
    @State public var a: Float = 0;
    @State private var currentDate = Date()
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return formatter
        }();
    @State private var selectedMenuItem: String = "Click the button to select a log ...";
    
    var body: some View {
        Text("Diaper Monitoring Panel")
            .font(.title.bold())
            .foregroundColor(Color("DarkColor"))
            .padding()
        
        Spacer();
            

        
        HStack{
            
            VStack{
                
                Text("Biochemical Monitoring")
                    .font(.headline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center);
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("LightColor"))
                        .frame(width: 115, height: 65)
                    
                    VStack {
                        Text("pH")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top, 5);
                        
                        Text("\(a)")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white);
                    }
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("LightColor"))
                        .frame(width: 115, height: 65)
                    
                    VStack {
                        Text("UA")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top, 5);
                        
                        Text("\(a+2)")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white);
                    }
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("LightColor"))
                        .frame(width: 115, height: 65)
                    
                    VStack {
                        Text("NT")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top, 5);
                        
                        Text("\(a*2)")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white);
                    }
                    
                }
                
            }
            
            Image("baby")
                .resizable()
                .frame(width: 125, height: 135)
                .cornerRadius(25);
            
            
            VStack{
                
                Text("Physical Monitoring")
                    .font(.headline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center);
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(a*5 >= 37.5 ? Color("WarnColor") : Color("LightColor"))
                        .frame(width: 115, height: 65)
                    
                    VStack {
                        Text("Body Temp 🌡️")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top, 5);
                        
                        Text("\(a*5)")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white);
                    }
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(a*10 >= 120 ? Color("WarnColor") : Color("LightColor"))
                        .frame(width: 115, height: 65)
                    
                    VStack {
                        Text("Heart Rate ❤️")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top, 5);
                        
                        Text("\(a*10)")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white);
                    }
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(a*2 >= 30 ? Color("WarnColor") : Color("LightColor"))
                        .frame(width: 115, height: 65)
                    
                    VStack {
                        Text("Humidity 💦")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top, 5);
                        
                        Text("\(a*2)")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white);
                    }
                    
                }
                
            } //Physical parameters VStack
            
            .onAppear {
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    a += 1
                }
                
            }
            
        } //Baby model HStack

        Spacer();
        
        VStack {
            
            Menu {
                
                Button("Body Temperature") {
                    
                    selectedMenuItem = "Body Temp";
                    auxtxt = "";
                    viewModel = GraphViewModel()

                }
                Button("Heart Rate") {
                    
                    selectedMenuItem = "Heart Rate";
                    auxtxt = "";
                    viewModel = GraphViewModel2()

                }
                Button("Humidity") {
                    
                    selectedMenuItem = "Humidity";

                }
                Button("pH") {
                    
                    selectedMenuItem = "pH";

                }
                Button("UA") {
                    
                    selectedMenuItem = "UA";

                }
                Button("NT") {
                    
                    selectedMenuItem = "NT";

                }
                
            } label: {
                
                Text("Select Monitor Log")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: 225)
                    .foregroundColor(Color("PrimaryColor1"))
                    .padding()
                    .background(Color.white)
                    .cornerRadius(150)
                    .shadow(color: .light, radius: 20, x: 8, y: 12)
                    .padding();
                
            }
            

            
            Text(selectedMenuItem)
                .font(.body.bold());

        }
        

            



        
        
        Spacer();
        
        Text(dateFormatter.string(from: currentDate))
            .font(.title)
            .multilineTextAlignment(.center)
            .onAppear {
                let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    currentDate = Date()
                }
                // Invalidate the timer when the view disappears to prevent memory leaks
                RunLoop.current.add(timer, forMode: .common)
            }
        
        Spacer();
        
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

#Preview {
    Monitor()
}
