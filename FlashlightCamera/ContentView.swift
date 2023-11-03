//
//  ContentView.swift
//  SlipiTes
//
//  Created by beni garcia on 29/09/23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var isFlashing = false
    @State private var flashInterval = 0.5
    @State private var flashTimer: Timer? = nil
    @State private var isMaxBrightness = false
    @State private var originalBrightness: CGFloat?
    
    var body: some View {
        VStack{
            Text("Flashlight Controller")
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                toggleFlashing()
            }) {
                Text(isFlashing ? "Turn Off Flashlight" : "Turn On Flashlight")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            Button(action: {
                self.isMaxBrightness.toggle()
                setScreenBrightness(maxBrightness: self.isMaxBrightness)
            }) {
                Text(isMaxBrightness ? "Set default brightness" : "Set Max Brightness")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
    
    func toggleFlashing() {
        if isFlashing {
            stopFlashing()
        } else {
            startFlashing()
        }
        isFlashing.toggle()
    }
    
    func startFlashing() {
        flashTimer = Timer.scheduledTimer(withTimeInterval: flashInterval, repeats: true) { _ in
            toggleFlashlight()
        }
    }
    
    func stopFlashing() {
        flashTimer?.invalidate() // Stop the flashing Timer
        flashTimer = nil
        if let device = AVCaptureDevice.default(for: AVMediaType.video) {
            if device.torchMode == .on {
                toggleFlashlight() // Turn off the flashlight when stopping flashing
            }
        }
    }
    
    func toggleFlashlight() {
        if let device = AVCaptureDevice.default(for: AVMediaType.video) {
            do {
                try device.lockForConfiguration()
                if device.hasTorch {
                    if device.torchMode == .off {
                        do {
                            try device.setTorchModeOn(level: 1.0)
                        } catch {
                            print("Error: \(error)")
                        }
                    } else {
                        device.torchMode = .off
                    }
                }
                device.unlockForConfiguration()
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func setScreenBrightness(maxBrightness: Bool) {
        
        if maxBrightness {
            originalBrightness = UIScreen.main.brightness
            UIScreen.main.brightness = 1.0 // Maximum brightness
        } else {
            if let original = originalBrightness {
                UIScreen.main.brightness = original
            }
        }
    }
    
    
    
    //    func toggleFlashlight() { on off
    //        if let device = AVCaptureDevice.default(for: AVMediaType.video) {
    //            do {
    //                try device.lockForConfiguration()
    //                if device.hasTorch {
    //                    if isFlashlightOn {
    //                        device.torchMode = AVCaptureDevice.TorchMode.off
    //                    } else {
    //                        do {
    //                            try device.setTorchModeOn(level: 1.0)
    //                        } catch {
    //                            print("Error: \(error)")
    //                        }
    //                    }
    //                }
    //                device.unlockForConfiguration()
    //                isFlashlightOn.toggle()
    //            } catch {
    //                print("Error: \(error)")
    //            }
    //        }
    //    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
