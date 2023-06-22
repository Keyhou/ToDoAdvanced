//
//  SplashView.swift
//  ToDoAdvanced
//
//  Created by Keyhou on 02/03/2023.
//

import SwiftUI

struct SplashView: View {
    @State var animate = false
    @State var endSplash = false
    //    @EnvironmentObject var movieViewModel: MovieViewModel
    @State var isActive: Bool = false
    @State var scale: CGFloat = 0
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    
    //    @Binding var shouldShowOnboarding: Bool
    
    //    var body: some View {
    //        VStack {
    //            if !self.isActive {
    ////                ZStack {
    ////                    Text("Take a deep breath")
    ////                    Spacer()
    //                    Image("SplashIcon")
    //                        .resizable()
    //                        .aspectRatio(contentMode: .fit)
    //                        .frame(width: 200, height: 200)
    //                        .padding()
    //                        .scaleEffect(scale)
    //                        .onAppear {
    //                            let baseAnimation = Animation.easeInOut(duration: 2)
    //                            let repeated = baseAnimation.repeatForever(autoreverses: true)
    //
    //                            withAnimation(repeated) {
    //                                scale = 100
    //                            }
    //                        }
    //                    //                                 Image("loadLogo2")
    //                    //                                     .resizable()
    //                    //                                     .aspectRatio(contentMode: .fit)
    //                    //                                     .frame(width: 200, height: 50)
    ////                }
    //            } else {
    //                ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    //            }
    //            //            .fullScreenCover(isPresented: $shouldShowOnboarding, content: { Onboarding(shouldShowOnboarding: $shouldShowOnboarding)}
    //            //            )
    //        }
    //
    //        .onAppear {
    //            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    //                withAnimation {
    //                    self.isActive = true
    //                }
    //            }
    //        }
    //    }
    
    
    var body: some View {
        ZStack {
            ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            
            ZStack {
                Color("splashcolor")
                
                Image("SplashIcon")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: animate ? .fill : .fit)
                    .frame(width: animate ? nil : 85, height: animate ? nil : 85)
                // Scaling View
                    .scaleEffect(animate ? 3 : 0.8)
                // setting width to avoid over size
                    .frame(width: .screenWidth)
            }
            .ignoresSafeArea(.all, edges: .all)
            .onAppear(perform: animateSplash)
            // hiding view after finished
            .opacity(endSplash ? 0 : 1)
        }
    }

  func animateSplash() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
      // You can adjust your own duration
      // or wait until data loads
      withAnimation(Animation.easeOut(duration: 0.55)) {
        animate.toggle()
      }
      
      withAnimation(Animation.linear(duration: 0.45)) {
        endSplash.toggle()
      }
    }
  }
    
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

extension CGFloat {
  static let screenWidth = UIScreen.main.bounds.width
  static let screenHeight = UIScreen.main.bounds.height
  
  //MARK: - Fonts size of the app
  static let capital: CGFloat = 90
  static let overlayText: CGFloat = 46
  static let header: CGFloat = 32
  static let sideText: CGFloat = 22
  static let subheadline: CGFloat = 19
}

