//
//  PlayerInviteView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/12.
//

import SwiftUI

struct PlayerInviteView: View {
    @EnvironmentObject var model: Model
    @EnvironmentObject var eventFlag: GameEventFlag
    @EnvironmentObject var RDDAO: RealtimeDatabeseDAO
    let room:Room
    
    init(_ room:Room) {
        self.room = room
    }
    
    var body: some View {
        VStack {
            
            InvitedPlayerListView(players: room.players)
            
            QRCodeView(room: room)
                .padding()
            
            if room.players.count > 1 {
                Button(action: {
                    DispatchQueue.main.async {
                        RDDAO.updateRoomStatus(roomId: room.id, state: .playing)
                        // FIXME: ホストが鬼となるように暫定対応
                        RDDAO.updatePlayerRole(roomId: room.id, playerId: room.host.id, role: .killer)
                        // 開始時間の取得および設定
                        let startTime = room.getStartTime()
                        RDDAO.updateGameStartTime(roomId: room.id, startTime: startTime)
                        // 逃走時間(秒)の取得
                        let escapeSec = room.rule.escapeTime * 60
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(escapeSec)) {
                            eventFlag.isEscaping = false
                            eventFlag.isGameStarted = true
                        }
                        DispatchQueue.main.async {
                            model.playerInvitePushed = false
                            DispatchQueue.main.async {
                                eventFlag.isEscaping = true
                            }
                        }
                    }
                    
                }) {
                    Text("ゲーム開始")
                        .frame(width: 240, height: 60, alignment: .center)
                }
                .buttonStyle(CustomButtomStyle(color: Color(UIColor(hex: "0BBB18"))))
            } else {
                Button(action: {
                    
                }) {
                    Text("ゲーム開始")
                }
                .buttonStyle(CustomButtomStyle(color: Color.gray))
                .disabled(true)
            }

            
        }.frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity
        ).background(Color(UIColor(hex: "212121"))).edgesIgnoringSafeArea(.all)
    }
}
