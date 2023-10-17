//
//  Alerts.swift
//  Tic-Tac-Toe
//
//  Created by User on 17/10/23.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let titulo: Text
    let mensagem: Text
    var buttonTitulo: Text
}


struct AlertContext {
  static let vitoriaHumano = AlertItem(titulo: Text("Você Venceu!"),
                                  mensagem: Text("Você é melhor que a IA!"),
                                  buttonTitulo: Text("Isso ai"))
    
   static let vitoriaComputador = AlertItem(titulo: Text("Você perdeu!"),
                                  mensagem: Text("Esse programa é uma super IA!😎"),
                                  buttonTitulo: Text("Revanche"))
    
  static  let empate = AlertItem(titulo: Text("Empate!"),
                                  mensagem: Text("Fique pronto para a proxima batalha!😎"),
                                  buttonTitulo: Text("Tente Novamente"))
    
    
    
    
    
}
