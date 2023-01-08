//
//  MarvelAPI.swift
//  HeroisMarvel
//
//  Created by Humberto Rodrigues on 05/01/23.
//  Copyright © 2023 Eric Brito. All rights reserved.
//

import Foundation
import Alamofire
import SwiftHash

class MarvelAPI {
    static private let baseURL = "https://gateway.marvel.com/v1/public/characters?"
    private static let privateKey = "9645619994ba2314ce46c094cc12f8da7d36e07a"
    static private let publicKey = "d942186a84eae188917fa6d5ccbb3524"
    static private let limit = 50
    
    
    //MARK: FORMATANDO CREDENCIAIS ENCRIPTADAS CONFORME A API PEDE
    private class func getCredentials() -> String {
        let ts = String(Date().timeIntervalSinceNow)
        let hash = MD5(ts+privateKey+publicKey).lowercased()
        return "ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
    }
    
    //MARK: REGRA DE EMPAGINAÇÃO + String para buscar o personagem no servidor !
    class func loadHeroes(name: String?, page: Int = 0 , onComplete: @escaping (MarvelInfo?) -> Void){
        let offset = page * limit
        var startsWith: String
        if let name = name, !name.isEmpty {
            startsWith = "nameStartsWith=\(name.replacingOccurrences(of: " ", with: ""))&"
        } else {
            startsWith = ""
        }
        
        
        //MARK: TERMINANDO MINHA URL PARA REALIZAR O REQUEST !
        let url = baseURL + "offset=\(offset)&limit=\(limit)&" + startsWith + getCredentials()
        print (url)
       
            
        //MARK: USANDO O ALAMOFIRE PARA SIMPLIFICAR UMA REQUISIÇÃO AO SERVIDOR
        Alamofire.request(url).responseJSON { (response) in
            guard let data = response.data else {
                onComplete(nil)
                print("ERRO")
                return
            }
            do {
                let marvelInfo = try JSONDecoder().decode(MarvelInfo.self, from: data)
                onComplete(marvelInfo)
            } catch {
                print(error.localizedDescription)
                print(error)
                onComplete(nil)
            }
        }
    }
    
    
    
}
