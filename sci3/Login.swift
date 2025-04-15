//
//  Login.swift
//  sci3
//
//  Created by 章稼润 on 2024/6/29.
//

import SwiftUI

struct Login: View {
    var body: some View {
        NavigationView{
            ZStack{
                Color("bgc").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/);
                
                VStack{
                    Spacer();
                    Text("Smart Diaper Monitoring Mobile")
                        .padding(.vertical)
                        .font(.title2.bold())
                        .foregroundColor(Color("DarkColor"));
                    
                    Spacer();
                    Image("pic");
                    Spacer();
                    
                    NavigationLink{
                        Monitor();
                    } label: {
                        Button(action:{}){
                            
                        }
                        Text("Start Monitoring")
                        .font(.title3.bold())
                        .frame(maxWidth: 250)
                        .padding()
                        .foregroundColor(.white)
                        .background(
                            Color("PrimaryColor1")
                        )
                        .cornerRadius(75)
                        .buttonStyle(PlainButtonStyle());
                    }
                    
                    NavigationLink{
                        graphtest();
                    } label: {
                        Button(action:{}){
                        }
                        Text("Bluetooth Connection")
                        .font(.title3.bold())
                        .frame(maxWidth: 250)
                        .foregroundColor(Color("PrimaryColor1"))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(75)
                        .shadow(color: .green.opacity(0.25), radius: 65, x: 0, y: 16)
                        .padding(.vertical)
                        .buttonStyle(PlainButtonStyle());
                    }
                    
                    
                    
                    
                    HStack{
                        Text("First time?");
                        
                    NavigationLink (destination: Help()) {
                        Text("Help")
                            .foregroundColor(Color("PrimaryColor1"))
                    }
                        
                    }
                }

            }
        }
    }
}

#Preview {
    Login()
}

        
