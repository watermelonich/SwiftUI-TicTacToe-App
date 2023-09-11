//
//  MPGameMove.swift
//  Tic Tac Toe
//
//  Created by Nich on 9/11/23.
//

import Foundation

struct MPGameMove: Codable {
    enum Action: Int, Codable {
        case start, move, reset, end
    }
        let action: Action
        let playerName: String?
        let index: Int?
    
        func data ( ) -> Data? {
            try? JSONEncoder () . encode (self)
    }
}
