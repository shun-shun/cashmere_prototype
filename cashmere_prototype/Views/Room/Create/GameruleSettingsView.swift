//
//  GameruleSettingsView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/17.
//

import SwiftUI

struct GameruleSettingsView: View {
    @EnvironmentObject var gameSet: GameSettingObserve
    
    var body: some View {
        VStack {
            Text("ルール設定").font(.title).padding(.top, 20)
            HStack {
                Text("制限時間")
                    .lineLimit(nil)
                    .padding()
                    .foregroundColor(.black)
                    .font(.caption)
                
                Spacer()
                
                Picker("", selection: $gameSet.hour) {
                    ForEach(0 ..< 100) { num in
                        Text(String(num) + "時間")
                            .foregroundColor(.black)
                    }
                }
                .frame(width: 120, height: 60, alignment: .center)
                .labelsHidden()
                .compositingGroup()
                .clipped()
                
                Picker("", selection: $gameSet.minute) {
                    ForEach(1 ..< 60) { num in
                        Text(String(num) + "分")
                            .foregroundColor(.black)
                    }
                }
                .frame(width: 120, height: 60, alignment: .center)
                .labelsHidden()
                .compositingGroup()
                .clipped()
                
            }
            .padding(.vertical)
            HStack {
                Text("逃走時間")
                    .lineLimit(nil)
                    .padding(20)
                    .foregroundColor(.black)
                    .font(.callout)
                
                Spacer()
                Picker("", selection: $gameSet.escapeTime) {
                    ForEach(1 ..< 60) { num in
                        Text(String(num) + "分")
                            .foregroundColor(.black)
                    }
                }
                .frame(width: 120, height: 60, alignment: .center)
                .labelsHidden()
                .compositingGroup()
                .clipped()
                
            }
            .padding(.vertical)
            HStack {
                Text("逃走範囲")
                    .lineLimit(nil)
                    .padding(20)
                    .foregroundColor(.black)
                    .font(.callout)
                
                Spacer()
                Picker("", selection: $gameSet.escapeRange) {
                    ForEach(1 ..< 500) { num in
                        Text(String(num * 10) + "m")
                            .foregroundColor(.black)
                    }
                }
                .frame(width: 120, height: 60, alignment: .center)
                .labelsHidden()
                .compositingGroup()
                .clipped()
                
            }
            .padding(.vertical)
            HStack {
                Text("鬼の捕獲範囲")
                    .lineLimit(nil)
                    .padding(20)
                    .foregroundColor(.black)
                    .font(.callout)
                
                Spacer()
                
                Picker("", selection: $gameSet.killerCaptureRange) {
                    ForEach(1 ..< 100) { num in
                        Text(String(num) + "m")
                            .foregroundColor(.black)
                    }
                }
                .frame(width: 120, height: 60, alignment: .center)
                .labelsHidden()
                .compositingGroup()
                .clipped()
            }
            .padding(.vertical)
            HStack {
                Text("生存者の位置情報送信間隔")
                    .padding(20)
                    .foregroundColor(.black)
                    .lineLimit(nil)
                    .font(.caption)
                
                Spacer()
                
                Picker("", selection: $gameSet.survivorPositionTransmissionInterval) {
                    ForEach(1 ..< 100) { num in
                        Text(String(num) + "分")
                            .foregroundColor(.black)
                    }
                }
                .frame(width: 120, height: 60, alignment: .center)
                .labelsHidden()
                .compositingGroup()
                .clipped()
            }
            .padding(.vertical)
        }
        .background(Color(UIColor(hex: "AAAAAA")))
        .cornerRadius(10)
    }
}
