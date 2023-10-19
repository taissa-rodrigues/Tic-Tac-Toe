//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by user on 16/10/23.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var ViewModel = GameViewModel()
    
    var body: some View {
        
        
        GeometryReader { geometry in
            VStack {
                Spacer()
                Text("Tic Tac Toe")
                    .font(.title3)
                    
                Spacer()
                LazyVGrid(columns: ViewModel.columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack {
                            Circle()
                                .foregroundColor(.pink).opacity(0.5)
                                .frame(width: geometry.size.width/3 - 15,
                                       height: geometry.size.width/3-15)
                            Image(systemName: ViewModel.movimentos[i]?.indicador ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                            
                        }
                        .onTapGesture {
                            ViewModel.processarMovimentoJogador(for: i)
                        }
                    }
                }
                Spacer()
            }
            .disabled(ViewModel.gameDesabilitado)
            .padding()
            .alert(item: $ViewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.titulo,
                      message: alertItem.mensagem,
                      dismissButton: .default(alertItem.buttonTitulo,action: { ViewModel.resetJogo() }))
            })
        }
    }
   
}
    enum Player {
        case humano, computador
    }

    struct Mover {
        let player: Player
        let boardIndex: Int
        
        
    var indicador: String {
            return player == .humano ? "xmark": "circle"
        }
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            GameView()
        }
    }

