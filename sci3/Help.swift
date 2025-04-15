//
//  Help.swift
//  sci3
//
//  Created by 章稼润 on 2024/6/30.
//

import SwiftUI

struct Help: View {
    var body: some View {
        ScrollView{
            Text("Notice before use")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 8){
                Text("Hello World")
                    .font(.subheadline)
                    .frame(minWidth: 0, maxWidth: 375, alignment: .leading)
                Text(">> Smart Monitoring System")
                    .font(.title3.bold())
                    .foregroundColor(Color("DarkColor"))
                    .frame(minWidth: 0, maxWidth: 375, alignment: .leading);
                Text("Hello World")
                    .font(.subheadline)
                    .frame(minWidth: 0, maxWidth: 375, alignment: .leading);
                Text("1. Heart Rate")
                    .font(.headline)
                    .foregroundColor(Color("DarkColor"))
                    .frame(minWidth: 0, maxWidth: 375, alignment: .leading);
                Text("Hello World")
                    .font(.subheadline)
                    .frame(minWidth: 0, maxWidth: 375, alignment: .leading);
                Text("2. Body Temperature")
                    .font(.headline)
                    .foregroundColor(Color("DarkColor"))
                    .frame(minWidth: 0, maxWidth: 375, alignment: .leading);
                Text("Hello World")
                    .font(.subheadline)
                    .frame(minWidth: 0, maxWidth: 375, alignment: .leading);
                Text("3. Humidity")
                    .font(.headline)
                    .foregroundColor(Color("DarkColor"))
                    .frame(minWidth: 0, maxWidth: 375, alignment: .leading);
                Text("Hello World")
                    .font(.subheadline)
                    .frame(minWidth: 0, maxWidth: 375, alignment: .leading);
                Text("4. pH")
                    .font(.headline)
                    .foregroundColor(Color("DarkColor"))
                    .frame(minWidth: 0, maxWidth: 375, alignment: .leading);
                Text("Hello World")
                    .font(.subheadline)
                    .frame(minWidth: 0, maxWidth: 375, alignment: .leading);
                Text("5. Uric Acid (UA)")
                    .font(.headline)
                    .foregroundColor(Color("DarkColor"))
                    .frame(minWidth: 0, maxWidth: 375, alignment: .leading);
                Text("Hello World")
                    .font(.subheadline)
                    .frame(minWidth: 0, maxWidth: 375, alignment: .leading);
                Text("6. Nitrite (NT)")
                    .font(.headline)
                    .foregroundColor(Color("DarkColor"))
                    .frame(minWidth: 0, maxWidth: 375, alignment: .leading);
                Text("Hello World")
                    .font(.subheadline)
                    .frame(minWidth: 0, maxWidth: 375, alignment: .leading);
            }
        }
    }
}

struct Help_Previews: PreviewProvider {
    static var previews: some View {
        Help();
    }
}
