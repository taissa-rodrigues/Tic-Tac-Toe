//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by user on 16/10/23.
//

import SwiftUI

struct ContentView: View {
    let columns: [GridItem] =  [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible()),]
    @State private var movimentos: [Mover?] = Array(repeating: nil, count: 9)
    @State private var gameDesabilitado = false
        
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: columns) {
                    ForEach(0..<9) { i in
                        ZStack {
                            Circle()
                                .foregroundColor(.pink).opacity(0.5)
                                .frame(width: geometry.size.width/3 - 15,
                                       height: geometry.size.width/3-15)
                            Image(systemName: movimentos[i]?.indicador ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                            
                        }
                        .onTapGesture {
                            
                            if quadradoOcupado(in: movimentos, forIndex: i) {return}
                            movimentos[i] = Mover(player: .humano, boardIndex: i)
                            gameDesabilitado = true
                            
                            
                            // verifcar condicao de vitoria
                            
                            if checarCondicaoVitoria(for: .humano, in: movimentos) {
                                print("huamano vence")
                                return
                            }
                            // empate
                            if checarEmpate(in: movimentos) {
                                print("empate")
                                return
                            }
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                
                                let computadorPosicao = determinarPosicaoComputador(in: movimentos)
                                movimentos[computadorPosicao] = Mover(player: .computador, boardIndex: computadorPosicao)
                                gameDesabilitado = false
                                
                                if checarCondicaoVitoria(for: .computador, in: movimentos) {
                                    print("computador vence")
                                    return
                                }
                                
                                if checarEmpate(in: movimentos) {
                                    print("empate")
                                    return
                                }

                            }
                        }
                    }
                }
                Spacer()
            }
            .disabled(gameDesabilitado)
            .padding()
            
        }
    }
    func quadradoOcupado( in movimentos: [Mover?], forIndex index: Int) -> Bool {
        return movimentos.contains(where: {$0? .boardIndex == index})
    }
    
    func determinarPosicaoComputador (in movimentos: [Mover?]) -> Int {
            var moverPosicao = Int.random(in: 0..<9)
        
        while quadradoOcupado(in: movimentos, forIndex: moverPosicao) {
             moverPosicao = Int.random(in: 0..<9)
            
    }
    return moverPosicao
 }
    
    func checarCondicaoVitoria( for player: Player, in movimentos: [Mover?]) -> Bool {
        let padraoVitoria: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5],[6, 7, 8],[0,3,6],[1, 4, 7], [2, 5, 8],[0,4,8],[2,4,6]]
        
        let playerMovimentos = movimentos.compactMap
            { $0 }.filter {$0.player == player}
        let playerPosicao = Set(playerMovimentos.map{$0.boardIndex})
        
        for vitoria in padraoVitoria  where vitoria.isSubset(of: playerPosicao){
            return true}
            return true
        
    }
    func checarEmpate (in movimentacao: [Mover?]) -> Bool {
        return movimentacao.compactMap { $0 }.count == 9
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
            ContentView()
        }
    }

