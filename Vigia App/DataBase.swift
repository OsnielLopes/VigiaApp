//
//  DataBaseManager.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 26/04/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import Foundation

class DataBase {
    
    class CondominioManager {
        static func getCondominioForToken(token: String, completion:@escaping (_ isValid: String?)->Void) {
            let url = URL(string: "http://plataforma.v8monitoramento.com.br/api/condominios/validaToken.php?token=\(token)")
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                guard let data = data else {
                    print("Impossible to get the data from the server. Requisition: \(String(describing: url?.absoluteString))")
                    completion(nil)
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let condCodArray = try decoder.decode([[String:String]].self, from: data)
                    guard let condCod = condCodArray.first?.first?.value else {
                        print("Impossible to get the value from the condCodArray")
                        completion(nil)
                        return
                    }
                    completion(condCod)
                } catch let error {
                    print(error.localizedDescription)
                    completion(nil)
                }
                
            }
            task.resume()
        }
    }
    
    class CredencialManager {
        
        private static var sharedInstance: CredencialManager = {
            return CredencialManager()
        }()
        
        class var shared: CredencialManager {
            get{
                return sharedInstance
            }
        }
        
        static func get(usuario: String, senha: String, completion: @escaping (_ credencial: Credencial?)->Void) {
            let url = URL(string: "http://plataforma.v8monitoramento.com.br/api/credenciais/readUser.php?usuario=\(usuario)&senha=\(senha)")
            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                guard let data = data else {
                    print("Impossible to get the data from the server. Requisition: \(String(describing: url?.absoluteString))")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let credencialArray = try decoder.decode([Credencial].self, from: data)
                    if credencialArray.count > 0 {
                        let credencial = credencialArray.first
                        UserDefaults().set(credencial?.pessoas_id, forKey: "user_pessoas_id")
                        UserDefaults().set(credencial?.id, forKey: "user_credencial_id")
                        UserDefaults().set(credencial?.bases_id, forKey: "user_bases_id")
                        UserDefaults().set(credencial?.nivelAcesso, forKey: "nivel_acesso")
                        completion(credencial)
                    } else {
                        completion(nil)
                    }
                } catch let error {
                    print(error)
                    completion(nil)
                }
            }
            task.resume()
        }
    }
    
    class PermissaoManager {
        
        static func get(usuarioId: Int, completion: @escaping (_ permissoes: [Permissao])->Void) {
            let url = URL(string: "http://plataforma.v8monitoramento.com.br/api/permissoes/readPermissaoBySalvoPor.php?salvopor=\(usuarioId)")
            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                
                guard let data = data else {
                    print("Impossible to get the data from the server. Requisition: \(String(describing: url?.absoluteString))")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    let permissoes = try decoder.decode([Permissao].self, from: data)
                    completion(permissoes)
                } catch let error {
                    print(error)
                    if let error = error as? DecodingError {
                        switch error {
                        case .typeMismatch(_, let y):
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
            
            task.resume()
        }
        
        static func create(json: [String:Any], completion: @escaping (_ saved: Bool)->Void) {
            
            //nome, rg, inicioliberacao, fimliberacao, diasliberacao, horainicio, horafim, unidades_id, bases_id, salvopor
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .sortedKeys)
            print(String(data: jsonData!, encoding: .utf8))
            // create post request
            let url = URL(string: "http://plataforma.v8monitoramento.com.br/api/permissoes/create.php")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            print("INICIOU TASK URL")
            
            let task = URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
                print("TASK URL EXECUTANDO")
                
                guard let data = data, error == nil else {
                    
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
                print(String(data: data, encoding: .utf8))
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
                completion(true)
            }
            task.resume()
        }
        
        static func mudarStatus(status: Int = 0, pessoasId: Int, salvopor: Int, completion: @escaping (_ didSabe: Bool)->Void){
            
            DataBase.MoradorManager.getUnidade(for: UserDefaults.standard.integer(forKey: "user_pessoas_id")) { (unidade) in
                
                guard let unidade = unidade else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                
                let url = URL(string: "http://plataforma.v8monitoramento.com.br/api/permissoes/deleteVisitor.php?salvopor=\(salvopor)&pessoaid=\(pessoasId)&unidadeid=\(unidade)")!
                let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                    
                    guard let data = data, error == nil else {
                        print(error?.localizedDescription ?? "No data")
                        return
                    }
                    
                    print("Response data: \(String(data: data, encoding: .utf8) ?? "no data")")
                    
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                    }
                    DispatchQueue.main.async {
                        completion(true)
                    }
                }
                task.resume()
            }
        }
        
        static func createMorador(with json: [String:Any], completion: @escaping (_ saved: Bool?)->Void){
            let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .sortedKeys)
            print(String(data: jsonData!, encoding: .utf8))
            // create post request
            let url = URL(string: "http://plataforma.v8monitoramento.com.br/api/morador/create.php")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            print("INICIOU TASK URL")
            
            let task = URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
                print("TASK URL EXECUTANDO")
                
                guard let data = data, error == nil else {
                    
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
                print(String(data: data, encoding: .utf8))
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
                completion(true)
            }
            task.resume()
        }
        
    }
    
    class PessoaManager {
        
        struct NomeResponse: Decodable {
            var nome: String!
            
            enum CodingKeys: String, CodingKey {
                case nome = "NOME"
            }
            
            init(from decoder: Decoder) {
                do {
                    let values = try decoder.container(keyedBy: CodingKeys.self)
                    self.nome = try values.decode(String.self, forKey: .nome)
                } catch let error {
                    print(error.localizedDescription)
                    if let error = error as? DecodingError{
                        switch error {
                            
                        case .typeMismatch(_, let y):
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
        
        static func getNome(pessoaId: Int, completion: @escaping (_ nome: String?)->Void) {
            let url = URL(string: "http://plataforma.v8monitoramento.com.br/api/pessoas/getNome.php?id=\(pessoaId)")
            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                
                guard let data = data else {
                    print("Impossible to get the data from the server. Requisition: \(String(describing: url?.absoluteString))")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let nomes = try decoder.decode([NomeResponse].self, from: data)
                    if nomes.count >= 1 {
                        completion(nomes.first!.nome)
                    } else {
                        completion(nil)
                    }
                    
                } catch let error {
                    print(error)
                }
            }
            
            task.resume()
        }
        
        static func getRG(pessoaId: Int, completion: @escaping (_ rg: String?)->Void) {
            let url = URL(string: "http://plataforma.v8monitoramento.com.br/api/pessoas/read.php?id=\(pessoaId)&attributes=RG")
            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                
                guard let data = data else {
                    print("Impossible to get the data from the server. Requisition: \(String(describing: url?.absoluteString))")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let rgs = try decoder.decode([[String:String]].self, from: data).first
                    DispatchQueue.main.async {
                        guard var rgs = rgs else {
                            completion(nil)
                            return
                        }
                        if rgs.count >= 1 { completion(rgs.popFirst()?.value) }
                    }
                } catch let error {
                    print(error)
                }
            }
            
            task.resume()
        }
    }
    
    class ListaEventoManager {
        
        static func create(nome: String, unidadeid: Int, date: String, inicio: String, fim: String, salvopor: Int, completion: @escaping (_ saved: Bool)->Void) {
        
            let address = "http://plataforma.v8monitoramento.com.br/api/listafesta/createEvent.php"
            let inicioAttribute = "\(inicio):00"
            let fimAttribute = "\(fim):00"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let datePlaceholder = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateAttribute = dateFormatter.string(from: datePlaceholder!)
            var attributes = "?nome=\(nome)&unidadeid=\(unidadeid)&data=\(dateAttribute)&inicio=\(inicioAttribute)&fim=\(fimAttribute)&salvopor=\(salvopor)"
            attributes = attributes.replacingOccurrences(of: " ", with: "%20")
            let urlString = address+attributes
            let url = URL(string: urlString)
            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
                completion(true)
            }
            task.resume()
        }
        
        static func get(salvopor: Int, unidade: Int, completion: @escaping (_ festas: [Evento]?)->Void){
            let url = URL(string: "http://plataforma.v8monitoramento.com.br/api/listafesta/readEvent.php?salvopor=\(salvopor)&unidade=\(unidade)")
            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                
                guard let data = data else {
                    print("Impossible to get the data from the server. Requisition: \(String(describing: url?.absoluteString))")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    let festas = try decoder.decode([Evento].self, from: data)
                    completion(festas)
                    
                } catch let error {
                    print(error)
                    completion(nil)
                }
            }
            
            task.resume()
        }
        
        static func getConvidados(to festaId: Int, completion: @escaping (_ convidados: [Convidado]?)->Void) {
            
            let url = URL(string: "http://plataforma.v8monitoramento.com.br/api/visitante_festa/read.php?listafestaid=\(festaId)")
            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                
                guard let data = data else {
                    print("Impossible to get the data from the server. Requisition: \(String(describing: url?.absoluteString))")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let convidados = try decoder.decode([Convidado].self, from: data)
                    completion(convidados)
                } catch let error {
                    print(error)
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
            
            task.resume()
        }
        
        static func insertConvidado(into festaId: Int, convidado pessoasId: Int,  completion: @escaping (_ didSave: Bool)->Void) {
            
            let url = URL(string: "http://plataforma.v8monitoramento.com.br/api/listafesta/updateVisitanteFesta.php?listafestaid=\(festaId)&pessoaid=\(pessoasId)")
            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                
                guard let data = data else {
                    print("Impossible to get the data from the server. Requisition: \(String(describing: url?.absoluteString))")
                    return
                }
                guard let response = String(data: data, encoding: .utf8) else {
                    print("Impossible to convert the data to String")
                    completion(false)
                    return
                }
                if response == "1"{
                    completion(true)
                } else {
                    print(response)
                    completion(false)
                }
            }
            
            task.resume()
        }
    }
    
    class MoradorManager {
        static func getUnidade(for pessoas_id: Int, completion: @escaping (_ unidade_id: Int?)->Void){
            let url = URL(string: "http://plataforma.v8monitoramento.com.br/api/morador/getUnidadeByPessoasId.php?pessoasid=\(pessoas_id)")
        
            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                
                guard let data = data else {
                    print("Impossible to get the data from the server. Requisition: \(String(describing: url?.absoluteString))")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    guard var idDictionary = try decoder.decode([[String:String]].self, from: data).first else {
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                        return
                    }
                    let id = Int((idDictionary.popFirst()?.value)!)
                    DispatchQueue.main.async {
                        completion(id)
                    }
                } catch let error {
                    print(error)
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
            task.resume()
            
        }
    }
    
    class UnidadeManager {
        static func getUnidades(for condCod: String, completion: @escaping (_ unidades: [Unidade]?)->Void){
            let url = URL(string: "http://plataforma.v8monitoramento.com.br/api/unidades/getUnidadesForCond.php?condCod=\(condCod)")
            
            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                
                guard let data = data else {
                    print("Impossible to get the data from the server. Requisition: \(String(describing: url?.absoluteString))")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let unidades = try decoder.decode([Unidade].self, from: data)
                    DispatchQueue.main.async {
                        completion(unidades)
                    }
                } catch let error {
                    print(error)
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
            task.resume()
            
        }
    }
    
}




