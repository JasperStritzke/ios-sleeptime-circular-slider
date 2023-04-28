//
//  ContentView.swift
//  PracticeAppleSleep
//
//  Created by Jasper Stritzke on 14.10.22.
//

import SwiftUI

struct Config {
    let radius: CGFloat
    let knobRadius: CGFloat
    //the smallest amount of hours sleep, you can configure
    let minSleepDuration: CGFloat
    //24 hours in minutes, seperated in 15 minute blocks
    let countSteps: Int
    
    var diameter: CGFloat {
        return radius * 2
    }
    
    var knobDiameter: CGFloat {
        return knobRadius * 2
    }
}

let config = Config(
    radius: 150.0 ,
    knobRadius: 22.0,
    minSleepDuration: 1.0,
    countSteps: 24*60/10
)

struct ContentView: View {
    
    @State var rotationSleep = 0.0
    @State var rotationWakeup = 90.0
    
    var totalSleepDuration: Double {
        let mappedSleep = mapRotationToTime(degrees: rotationSleep)
        var mappedWakeup = mapRotationToTime(degrees: rotationWakeup)
        
        if mappedSleep > mappedWakeup {
            mappedWakeup += 24
        }
        
        return mappedWakeup - mappedSleep;
    }
    
    func getFormattedSleepDuration() -> String {
        let duration = totalSleepDuration
        
        //truncuate decimals
        let hours = Int(duration)
        
        //remove full numbers and use rest to calculate the fraction of an hour
        var min = Int((duration-Double(hours))*60)
        
        //Round angle to always snap to minutes, that are multiples of 5 (5, 10, 15, 20, 25, ...)
        while min % 5 != 0 {
            min -= 1
        }
        
        if min == 0 {
            return "\(hours) Std."
        }
        
        return "\(hours) Std. \(min) Min."
    }
    
    func mapRotationToTime(degrees: Double) -> Double {
        let steps = 24.0 / 360.0
        
        return steps * degrees
    }
    
    var connectorLength: Double {
        if rotationSleep > rotationWakeup {
            return abs((rotationSleep-360-rotationWakeup)/360.0)
        }
        
        return (rotationWakeup-rotationSleep)/360.0
    }
    
    func getSleepTime() -> String {
        let sleepTimeHour = 24 / 360 * rotationSleep;
        
        //truncuate decimals
        let onlyHours = Int(sleepTimeHour)
        
        //remove full numbers and use rest to calculate the fraction of an hour
        var onlyMinutes = Int((sleepTimeHour-Double(onlyHours))*60)
        
        //Round angle to always snap to minutes, that are multiples of 5 (5, 10, 15, 20, 25, ...)
        while onlyMinutes % 5 != 0 {
            onlyMinutes -= 1
        }
        
        return (onlyHours <= 9 ? "0" + String(onlyHours) : String(onlyHours)) + ":" + (onlyMinutes <= 9 ? "0" + String(onlyMinutes) : String(onlyMinutes))
    }
    
    func getWakeUpTime() -> String {
        let sleepTimeHour = 24 / 360 * rotationWakeup;
        
        //truncuate decimals
        let onlyHours = Int(sleepTimeHour)
        
        //remove full numbers and use rest to calculate the fraction of an hour
        var onlyMinutes = Int((sleepTimeHour-Double(onlyHours))*60)
        
        //Round angle to always snap to minutes, that are multiples of 5 (5, 10, 15, 20, 25, ...)
        while onlyMinutes % 5 != 0 {
            onlyMinutes -= 1
        }
        
        return (onlyHours <= 9 ? "0" + String(onlyHours) : String(onlyHours)) + ":" + (onlyMinutes <= 9 ? "0" + String(onlyMinutes) : String(onlyMinutes))
    }
    
    let grayColor = Color(red: 44/255, green: 44/255, blue: 46/255)
    let labelColor = Color(red: 115/255, green: 114/255, blue: 118/255)
    let knobHover = Color(red: 28/255, green: 28/255, blue: 29/255)
    
    @State var didTapSleep = false
    @State var didTapWakeup = false
    
    var body: some View {
        ZStack {
            grayColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack(spacing: 50) {
                    VStack {
                        HStack {
                            Image(systemName: "bed.double")
                                .foregroundColor(.mint)
                                .font(.system(size: 12))
                            
                            Text("Schlafenszeit".uppercased())
                                .bold()
                                .foregroundColor(.white.opacity(0.3))
                                .font(.system(size: 14))
                        }
                        Text(getSleepTime())
                            .bold()
                            .foregroundColor(.white)
                            .font(.system(size: 22))
                        
                        Text("Morgen")
                            .bold()
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    
                    VStack {
                        HStack {
                            Image(systemName: "alarm")
                                .foregroundColor(.red)
                                .font(.system(size: 12))
                            
                            Text("Wecker".uppercased())
                                .bold()
                                .foregroundColor(.white.opacity(0.3))
                                .font(.system(size: 14))
                        }
                        Text(getWakeUpTime())
                            .bold()
                            .foregroundColor(.white)
                            .font(.system(size: 22))
                        
                        Text("Morgen")
                            .bold()
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                Spacer()
                
                HStack {
                    Text(String(getFormattedSleepDuration()))
                        .bold()
                        .foregroundColor(.white)
                        .font(.system(size: 22))
                }
            }
            
            ZStack {
                Circle()
                    .stroke(.black.opacity(0.9), lineWidth: config.knobDiameter*1.32)
                    .frame(width: config.diameter, height: config.diameter)
                
                Circle()
                    .trim(from: 0, to: connectorLength)
                    .stroke(grayColor, lineWidth: config.knobDiameter)
                    .frame(width: config.diameter, height: config.diameter)
                    .rotationEffect(Angle(degrees: rotationSleep-90))
                //                .gesture(
                //                    DragGesture(minimumDistance: 0)
                //                )
                
                ForEach((1...config.countSteps).reversed(), id: \.self) { i in
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 3, height: config.knobRadius*0.9)
                        .foregroundColor(.black.opacity(0.3))
                        .offset(y: config.radius)
                        .rotationEffect(
                            Angle(degrees: 360/Double(config.countSteps) * Double(i))
                        )
                }
                
                ForEach(1...(24*4), id: \.self) { i in
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 2, height: i % 4 != 0 ? 4 : 8)
                        .foregroundColor(.white.opacity(0.2))
                        .offset(y: config.radius - (i % 4 != 0 ? 40 : 42))
                        .rotationEffect(
                            Angle(degrees: 360/(24*4) * Double(i))
                        )
                }
                
                ForEach(1...24, id: \.self) { hour in
                    //                if hour % 2 == 0 {
                    ZStack {
                        Text(String(getHourStringByInt(hour)))
                            .font(.system(size: 16))
                            .bold()
                            .foregroundColor(hour % 3 == 0 ? .white : .white.opacity(0.5))
                            .rotationEffect(Angle(degrees: -(360.0/24*Double(hour))))
                    }
                    .offset(y: -(config.radius - 65))
                    .rotationEffect(Angle(degrees: 360.0/24*Double(hour)))
                    //                }
                }
                
                Image(systemName: "sun.max.fill")
                    .foregroundColor(.yellow)
                    .font(.system(size: 18))
                    .offset(y: 55)
                
                Image(systemName: "sparkles")
                    .foregroundColor(Color.mint)
                    .font(.system(size: 18))
                    .offset(y: -55)
                
                
                // Knob - start sleeping
                getKnob(icon: "bed.double", iconRotation: -rotationSleep, isTapped: didTapSleep, rotate: false)
                    .rotationEffect(Angle(degrees: rotationSleep))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { action in
                                change(action, ChangeType.SLEEP)
                            }
                    )
                
                // Knob - wake up
                getKnob(icon: "alarm", iconRotation: -rotationWakeup, isTapped: didTapWakeup, rotate: true)
                    .rotationEffect(Angle(degrees: rotationWakeup))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { action in
                                change(action, ChangeType.WAKEUP)
                            }
                    )
            }
        }
    }
    
    func getHourStringByInt(_ i: Int) -> String {
        if i == 24 {
            return "0"
        }
        
        if i % 2 == 0 {
            return String(i)
        }
        
        return ""
    }
    
    func getKnob(icon: String, iconRotation: Double, isTapped: Bool, rotate: Bool) -> some View {
        return ZStack {
            Circle()
                .trim(from: 0.25, to: 0.75)
                .foregroundColor(grayColor)
                .rotationEffect(Angle(degrees: rotate ? 180 : 0))
            
            Circle()
                .foregroundColor(isTapped ? knobHover : grayColor)
                .padding(5)
            Image(systemName: icon)
                .foregroundColor(labelColor)
                .font(.system(size: config.knobRadius/1.6))
                .bold()
                .rotationEffect(Angle(degrees: iconRotation))
        }
        .frame(width: config.knobDiameter, height: config.knobDiameter)
        .offset(y: -config.radius)
    }
    
    enum ChangeType {
        case SLEEP
        case WAKEUP
        case CONNECTOR
    }
    
    func calcAngle(x: CGFloat, y: CGFloat) -> Double {
        let vector = CGVector(dx: x, dy: y)
        
        var angle = (atan2(
            vector.dy - config.knobRadius, vector.dx - config.knobRadius
        ) + .pi / 2) / .pi * 180
        
        if angle < 0 {
            angle += 360
        }
        
        return angle
    }
    
    func change(_ action: DragGesture.Value, _ type: ChangeType) {
        let angle = calcAngle(x: action.location.x, y: action.location.y)
        
        switch type {
        case ChangeType.SLEEP:
            rotationSleep = angle
            break
        case ChangeType.WAKEUP:
            rotationWakeup = angle
            break
        default:
            return
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
