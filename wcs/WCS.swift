//
//  WCS.swift
//  wcs
//
//  Created by 章稼润 on 2024/7/10.
//

import SwiftUI
import UIKit


struct WCS: View {
    
    @State private var image: UIImage? = nil
    
    @State private var tempMappingImage: UIImage? = nil
    @State private var pHMappingImage: UIImage? = nil
    @State private var resultImage: UIImage? = nil
    
    @State private var recordImages: [UIImage?] = [nil, nil, nil, nil]
    @State private var showImagePicker = false
    @State private var addCounter = 0
    
    var body: some View {
        Text("Wound Care System")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(Color("ThemeColor"))
            .padding();
        
        Spacer().frame(height: 35)
        
        VStack{
            HStack{
                VStack {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 125, height: 125)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10);
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 2.5)
                            )
                            .frame(width: 125, height: 125)
                    }
                    
                    Text("Original")
                        .font(.body)
                        .fontWeight(.medium)

                    HStack{
                        
                        Button(action: {
                            self.showImagePicker = true
                        }) {
                            Text("Take")
                                .frame(width: 60, height: 30)
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .background(
                                    Color("ThemeColor")
                                )
                                .cornerRadius(20)
                                .buttonStyle(PlainButtonStyle());
                        }
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker(image: self.$image, showImagePicker: self.$showImagePicker) { capturedImage in
                                if let image = capturedImage {
                                    self.image = image
                                    self.recordImages[self.addCounter] = image
                                    self.addCounter = (self.addCounter + 1) % 4
                                }
                            }
                        }
                        
                        Button(action: {
                            self.tempMappingImage = UIImage(named: "onboard")
                            self.pHMappingImage = UIImage(named: "p1pic")
                            self.resultImage = UIImage(named: "baby")
                        }) {
                            Text("Run")
                                .frame(width: 60, height: 30)
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .background(
                                    Color("ThemeColor")
                                )
                                .cornerRadius(20)
                                .buttonStyle(PlainButtonStyle());
                        }
                        
                    }

                }
                
                Spacer().frame(width: 75);
                
                VStack{
                    if let image = tempMappingImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 125, height: 125)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10);
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 2.5)
                            )
                            .frame(width: 125, height: 125)
                    }
                    
                    Text("pH Mapping")
                        .font(.body)
                        .fontWeight(.medium)
                    
                    Spacer().frame(height: 41)
                    
                }

            }
            
            Spacer().frame(height: 30)
            
            HStack{
                VStack{
                    if let image = pHMappingImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 125, height: 125)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10);
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 2.5)
                            )
                            .frame(width: 125, height: 125)
                    }
                    
                    Text("Temp Mapping")
                        .font(.body)
                        .fontWeight(.medium)
                }
                   
                
                Spacer().frame(width: 75);
                
                VStack{
                    if let image = resultImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 125, height: 125)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10);
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 2.5)
                            )
                            .frame(width: 125, height: 125)
                    }
                    
                    Text("Result")
                        .font(.body)
                        .fontWeight(.medium)
                }
                       
            }
        }
        
        Spacer().frame(height: 30)
        
        Divider().background(Color.gray)
        
        Spacer().frame(height: 25)
        
        Text("Record")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(Color("ThemeColor"));
        
        Spacer().frame(height: 30)
        
        HStack{
            VStack{
                
                if let image = recordImages[0] {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10);
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2.5)
                        )
                        .frame(width: 80, height: 80)
                }
                
                Text("Day 1")
                    .font(.body)
                    .fontWeight(.medium)
                
            }

            Spacer().frame(width: 18);
            
            VStack{
                
                if let image = recordImages[1] {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10);
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2.5)
                        )
                        .frame(width: 80, height: 80)
                }
                
                Text("Day 2")
                    .font(.body)
                    .fontWeight(.medium)
            }
            
            Spacer().frame(width: 18);
            
            VStack{
                if let image = recordImages[2] {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10);
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2.5)
                        )
                        .frame(width: 80, height: 80)
                }
                
                Text("Day 3")
                    .font(.body)
                    .fontWeight(.medium)
            }
            
            Spacer().frame(width: 18);
            
            VStack{
                if let image = recordImages[3] {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10);
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2.5)
                        )
                        .frame(width: 80, height: 80)
                }
                
                Text("Day 4")
                    .font(.body)
                    .fontWeight(.medium)
            }
                   
        }
    }
}

#Preview {
    WCS()
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var showImagePicker: Bool
    var completionHandler: (UIImage?) -> Void

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
                parent.completionHandler(image) // Update recordImages in completionHandler
            }
            parent.showImagePicker = false
        }
    }
}
