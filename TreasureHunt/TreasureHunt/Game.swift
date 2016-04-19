//
//  Game.swift
//
//
//  Created by Jean Smits on 19/04/16.
//
//

import UIKit

class Game: NSObject {
    let riddles: [Riddles]
    let title: String
    

    init(title: String, riddles: [Riddles]) {
        
        self.title = title
        self.riddles = riddles
        super.init()

    }
    
}

class Riddles: NSObject {
    
    let answer: [Answer]
    let photo: String
    let summary: String
    let timestamp: NSDate
    
    init(answer: [Answer], photo:String, summary: String, timestamp: NSDate) {
        
        self.answer = answer
        self.photo = photo
        self.summary = summary
        self.timestamp = timestamp
        super.init()
    }
    
}


class Answer: NSObject {
    
    let answer_description: [String: Bool]
    
    init(answer_description: [String: Bool]) {
        
        self.answer_description = answer_description

    }
}

let game1Answers = Answer(answer_description: ["kat": true, "hond": false, "leeuw": false, "paard": false])
let game1Riddles = Riddles(answer: [game1Answers], photo: "kat", summary: "Welk dier zegt miauw", timestamp: NSDate())
let game1 = Game(title: "TestGame", riddles: [game1Riddles])
