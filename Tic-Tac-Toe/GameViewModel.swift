//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by user on 18/10/23.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    let columns: [GridItem] =  [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible()),]
    
    
    @Published var movimentos: [Mover?] = Array(repeating: nil, count: 9)
    @Published var gameDesabilitado = false
    @Published var alertItem: AlertItem?
    
    func processarMovimentoJogador (for posicao: Int) {
        if quadradoOcupado(in: movimentos, forIndex: posicao) {return}
        movimentos[posicao] = Mover(player: .humano, boardIndex: posicao)

        
        
        // verifcar condicao de vitoria
        
        if checarCondicaoVitoria(for: .humano, in: movimentos) {
            alertItem = AlertContext.vitoriaHumano
            return
        }
        // empate
        if checarEmpate(in: movimentos) {
            alertItem = AlertContext.empate
            return
        }
        
        gameDesabilitado = true
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            
            let computadorPosicao = determinarPosicaoComputador(in: movimentos)
            movimentos[computadorPosicao] = Mover(player: .computador, boardIndex: computadorPosicao)
            gameDesabilitado = false
            
            if checarCondicaoVitoria(for: .computador, in: movimentos) {
                alertItem = AlertContext.vitoriaComputador
                return
            }
            
            if checarEmpate(in: movimentos) {
                alertItem = AlertContext.empate
                return
            }

        }
    }
    
    
    
    func quadradoOcupado( in movimentos: [Mover?], forIndex index: Int) -> Bool {
        return movimentos.contains(where: {$0? .boardIndex == index})
    }
    
    // Se a IA pode vencer, então vença
    // Se a IA não puder vencer, bloqueie
    // Se a IA não puder bloquear, então pegue o quadrado do meio
    // Se a IA não puder pegar o quadrado do meio, pegue o quadrado aleatório disponível

    
    func determinarPosicaoComputador (in movimentos: [Mover?]) -> Int {
        // Se a IA pode vencer, então vença
        
        let padraoVitoria: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5],[6, 7, 8],[0,3,6],[1, 4, 7], [2, 5, 8],[0,4,8],[2,4,6]]
        let computadorMovimentos = movimentos.compactMap{ $0 }.filter {$0.player == .computador }
        
        let computadorPosicao = Set(computadorMovimentos.map {$0.boardIndex})
        
        for vitoria in padraoVitoria {
            let posicaoVitoria = vitoria.subtracting(computadorPosicao)
            
            if posicaoVitoria.count == 1 {
                let estaDisponivel = !quadradoOcupado(in: movimentos, forIndex: posicaoVitoria.first!)
                if estaDisponivel { return posicaoVitoria.first!}
                
            }
        }

        
        // Se a IA não puder vencer, bloqueie
        
        let humanoMovimentos = movimentos.compactMap{ $0 }.filter {$0.player == .humano }
        
        _ = Set(humanoMovimentos.map {$0.boardIndex})
        
        for vitoria in padraoVitoria {
            let posicaoVitoria = vitoria.subtracting(computadorPosicao)
            
            if posicaoVitoria.count == 1 {
                let estaDisponivel = !quadradoOcupado(in: movimentos, forIndex: posicaoVitoria.first!)
                if estaDisponivel { return posicaoVitoria.first!}
                
            }
        }

        // Se a IA não puder bloquear, então pegue o quadrado do meio
        
        let quadradoCentro = 4
        if !quadradoOcupado(in: movimentos, forIndex: quadradoCentro) {
            return quadradoCentro
        }
        
        
        var moverPosicao = Int.random(in: 0..<9)
        
        while quadradoOcupado(in: movimentos, forIndex: moverPosicao) {
             moverPosicao = Int.random(in: 0..<9)
            
    }
    return moverPosicao
 }
    
    func checarCondicaoVitoria( for player: Player, in movimentos: [Mover?]) -> Bool {
        let padraoVitoria: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5],[6, 7, 8],[0,3,6],[1, 4, 7], [2, 5, 8],[0,4,8],[2,4,6]]
        
        let playerMovimentos = movimentos.compactMap
            { $0 }.filter {$0.player == player }
        
        let playerPosicao = Set(playerMovimentos.map {$0.boardIndex})
        
        for vitoria in padraoVitoria  where vitoria.isSubset(of: playerPosicao) {return true}
            return false
        
    }
    func checarEmpate (in movimentacao: [Mover?]) -> Bool {
        return movimentacao.compactMap { $0 }.count == 9
    }
    
    func resetJogo() {
        movimentos = Array(repeating: nil, count: 9)
        
    }
    
}
