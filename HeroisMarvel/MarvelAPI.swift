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
    static private let basePath = "https://gateway.marvel.com:443/v1/public/characters?"
    static private let privateKey = "aceec6d431206ca589606c030342472a214a7fd7"
    static private let publicKey = "b24c84968a966c83e3d8d3546a8b272f"
    static private let limit = 50
    
    //MARK: FORMATANDO CREDENCIAIS ENCRIPTADAS CONFORME A API PEDE
    private class func getCredentials() -> String {
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(ts+privateKey+publicKey).lowercased()
        return "ts=\(ts)&apiKey=\(publicKey)&hash=\(hash)"
    }
    
    //MARK: REGRA DE EMPAGINAÇÃO + String para buscar o personagem no servidor !
    class func loadHeroes(name: String?,page: Int = 0 , onComplete: @escaping (MarvelInfo?) -> Void){
        let offset = page * limit
        let startsWith: String
        if let name = name, !name.isEmpty {
            startsWith = "nameStartsWith=\(name.replacingOccurrences(of: " ", with: ""))&"
        } else {
            startsWith = ""
        }
        
        //MARK: TERMINANDO MINHA URL PARA REALIZAR O REQUEST !
        let url = basePath + "offset=\(offset)&limit=\(limit)&" + startsWith + getCredentials()
        print(url)
        
        
        
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
