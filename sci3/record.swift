//
//  record.swift
//  sci3
//
//  Created by 章稼润 on 2024/7/5.
//

import SwiftUI

struct record: View {
    @State private var showingSheet = false
    @State private var t: Float = 0;
    @State private var tr: [Float] = [];
    @State private var trs: String = "";
    var body: some View {
        Text("\(t)")
            .onAppear {
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    t += 1
                    tr.append(t);
                    trs.append("t=\(t)\tpH=\(10*sin(t))\n")
                }
                
            }
            
           
        Button("Show Sheet") {
                    showingSheet = true
                }
        .sheet(isPresented: $showingSheet) {ScrollView(.vertical){
            Text(trs);
        }
                }
            }
        
        
    }


#Preview {
    record()
}
