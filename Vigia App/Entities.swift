//
//  Entities.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 28/04/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import Foundation
import UIKit

struct Credencial: Decodable {
    
    var id: Int!
    var usuario: String!
    var senha: String!
    var nivelAcesso: Int!
    var pessoas_id: Int!
    var bases_id: Int!
    var salvoEm: Date!
    var ativo: Bool!
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case usuario = "USUARIO"
        case senha = "SENHA"
        case nivelAcesso = "NIVELACESSO"
        case pessoas_id = "PESSOAS_ID"
        case bases_id = "BASES_ID"
        case salvoEm = "SALVOEM"
        case ativo = "ATIVO"
    }
    
    init(from decoder: Decoder) {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try Int(values.decode(String.self, forKey: .id))
            usuario = try values.decode(String.self, forKey: .usuario)
            senha = try values.decode(String.self, forKey: .senha)
            nivelAcesso = try Int(values.decode(String.self, forKey: .nivelAcesso))
            pessoas_id = try Int(values.decode(String.self, forKey: .pessoas_id))
            bases_id = try Int(values.decode(String.self, forKey: .bases_id))
            salvoEm = try values.decode(Date.self, forKey: .salvoEm)
            ativo = try values.decode(Bool.self, forKey: .ativo)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

struct Pessoa: Decodable {
    var id: Int!
    var nome: String!
    var rg: String!
    var salvoPor: Int!
    var salvoEm: Date!
    var ativo: Bool!
}

struct Base {
    var id: Int!
    var cnpj: String!
    var endereco: String!
    var bairro: String!
    var cidade: String!
    var estado: String!
    var cep: String!
    var telefone: String!
    var email: String!
}

struct Condominio {
    var codigo: Int!
    var nome: String!
    var cnpj: String!
    var endereco: String!
    var bairro: String!
    var cidade: String!
    var estado: String!
    var cep: String!
    var telefone: String!
    var email: String!
    var ip: String!
    var porta: Int!
    var palavrapasse: String!
    var basesid: [Int]
}

struct Festa: Decodable {
    var id: Int!
    var nome: String!
    var data: Date!
    var horaInicio: String!
    var horaFim: String!
    var ativo: Bool!
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case nome = "NOME"
        case data = "DATA"
        case horaInicio = "HORAINICIO"
        case horaFim = "HORAFIM"
        case ativo = "ATIVO"
    }
    
    init(from decoder: Decoder) {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try Int(values.decode(String.self, forKey: .id))
            nome = try values.decode(String.self, forKey: .nome)
            data = try values.decode(Date.self, forKey: .data)
            horaInicio = try values.decode(String.self, forKey: .horaInicio)
            horaFim = try values.decode(String.self, forKey: .horaFim)
            ativo = try Bool(values.decode(String.self, forKey: .ativo))

        } catch let error {
            print(error.localizedDescription)
            if let error = error as? DecodingError{
                switch error {
                case .typeMismatch( _, let y):
                    print(y.debugDescription)
                case .valueNotFound(_, let y):
                    print(y.debugDescription)
                case .keyNotFound(let x, let y):
                    print(x.debugDescription)
                    print(y.debugDescription)
                case .dataCorrupted(let x):
                    print(x.debugDescription)
                }
            }
        }
    }
}

struct Permissao: Decodable, Encodable {
    
    var permissao: Int!
    var inicioLiberacao: Date!
    var fimLiberacao: Date!
    var diasLiberacao: String!
    var horaInicio: String!
    var horaFim: String!
    var pessoasId: Int!
    var unidadesId: Int!
    var salvoEm: Date!
    var salvoPor: Int!
    var ativo: Bool!
    
    enum CodingKeys: String, CodingKey {
        case permissao = "PERMISSAO"
        case inicioLiberacao = "INICIOLIBERACAO"
        case fimLiberacao = "FIMLIBERACAO"
        case diasLiberacao = "DIASLIBERACAO"
        case horaInicio = "HORAINICIO"
        case horaFim = "HORAFIM"
        case pessoasId = "PESSOAS_ID"
        case unidadesId = "UNIDADES_ID"
        case salvoEm = "SALVOEM"
        case salvoPor = "SALVOPOR"
        case ativo = "ATIVO"
    }
    
    init(from decoder: Decoder) {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            permissao = try Int(values.decode(String.self, forKey: .permissao))
            inicioLiberacao = try values.decode(Date.self, forKey: .inicioLiberacao)
            fimLiberacao = try values.decode(Date.self, forKey: .fimLiberacao)
            diasLiberacao = try values.decode(String.self, forKey: .diasLiberacao)
            horaInicio = try values.decode(String.self, forKey: .horaInicio)
            horaFim = try values.decode(String.self, forKey: .horaFim)
            pessoasId = try Int(values.decode(String.self, forKey: .pessoasId))
            unidadesId = try Int(values.decode(String.self, forKey: .unidadesId))
            salvoEm = try values.decode(Date.self, forKey: .salvoEm)
            salvoPor = try Int(values.decode(String.self, forKey: .salvoPor))
            ativo = try Bool(values.decode(String.self, forKey: .ativo))
        } catch let error {
            print(error.localizedDescription)
            if let error = error as? DecodingError{
                switch error {
                    
                case .typeMismatch( _, let y):
                    print(y.debugDescription)
                case .valueNotFound(_, let y):
                    print(y.debugDescription)
                case .keyNotFound(let x, let y):
                    print(x.debugDescription)
                    print(y.debugDescription)
                case .dataCorrupted(let x):
                    print(x.debugDescription)
                }
            }
        }
    }

    func getNomesDias() -> [String] {
        let nomes = ["Domingo","Segunda","Terça","Quarta","Quinta","Sexta","Sábado"]
        var nomesRet = [String]()
        for i in 0..<self.diasLiberacao.count{
            if self.diasLiberacao[i] == "1" {
                nomesRet.append(nomes[i])
            }
        }
        return nomesRet
    }
}

