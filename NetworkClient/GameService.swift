//
//  GameService.swift
//  KumuApp
//
//  Created by mac on 30/06/21.
//

import Foundation
import Alamofire
import CodableAlamofire


typealias GameResponseHandler = (String?, GData?) ->(Void)
typealias ItemsListResponseHandler = (String?, Items?) ->(Void)
typealias ResultListResponseHandler = (String?, GameResults?) ->(Void)
typealias CommonResponseHandler = (Bool?, String?, String?) ->(Void)
typealias GameResultsResponseHandler = (String?,GameScores?) ->(Void)
typealias ScoreDeletedResponseHandler = (String?) ->(Void)
typealias ItemsHistoryListResponseHandler = (String?, [ItemsHistory]?) ->(Void)
typealias CoinSpentResponseHandler = (Bool?, String? , CoinSpent?) -> (Void)

struct ResponseData<T: Decodable>: Decodable {
    let code : Int?
    let message : String?
    let data : T?
}


protocol GameService {
    
    func createNewGame(params : Parameters, vc : UIViewController?, onCompletion : @escaping GameResponseHandler)
    func getItemsList(params : Parameters, vc : UIViewController?,onCompletion : @escaping ItemsListResponseHandler )
    func getItemsHistoryList( vc : UIViewController?,onCompletion : @escaping ItemsHistoryListResponseHandler )
    
    func getResultList(params : Parameters, vc : UIViewController?,onCompletion : @escaping ResultListResponseHandler )
    func saveGameResult(params : Parameters, vc : UIViewController?,onCompletion : @escaping CommonResponseHandler )
    func deleteScore(params: Parameters, vc: UIViewController?, onCompletion: @escaping ScoreDeletedResponseHandler)
    func spentCoin(params: Parameters, vc : UIViewController?, onCompletion: @escaping CoinSpentResponseHandler)
    func updateItems(params: Parameters,vc : UIViewController? ,onCompletion: @escaping CommonResponseHandler)
    func endgame(params: Parameters, vc : UIViewController?, onCompletion: @escaping CommonResponseHandler)
    func updateSetting(showAlert : Bool?,params : Parameters,vc : UIViewController?,onCompletion : @escaping CommonResponseHandler)

}

extension NetworkClient: GameService {
    
    //API for creating new Game.
    func createNewGame(params: Parameters,vc : UIViewController? ,onCompletion: @escaping GameResponseHandler) {
        
        vc?.showLoader()
        let request = self.postRequest(ApiName.create_game, parameters:params)
        mylog("createNewGame === \(baseURL)/\(ApiName.create_game) ||||||||||  parms ===\(params)")
        request.responseDecodableObject(decoder: self.decoder) { (response : DataResponse<ResponseData<GData>>) in
            vc?.hideLoader()
            if let error = response.result.error {
                print(error.localizedDescription)
                onCompletion(error.localizedDescription,nil)
                vc?.presentAlert(withTitle: "Error", andMessage: error.localizedDescription)
                return
            }
            //SUCCESS
            if response.result.value?.code == 200{
                onCompletion(response.result.value?.message, response.result.value?.data)
                return
            }else{
                onCompletion(response.result.value?.message,nil)
                vc?.presentAlert(withTitle: "Error", andMessage: response.result.value?.message ?? MessageConstant.errorMessage)
            }
        }
    }
    
    //API for getting Items-List
    func getItemsHistoryList(vc : UIViewController?, onCompletion: @escaping ItemsHistoryListResponseHandler) {
    
        vc?.showLoader()
        let request = self.postRequest(ApiName.item_history)
        mylog("getItemsHistoryList === \(baseURL)/\(ApiName.item_history) ||||||||||  request ===\(request)")
        request.responseDecodableObject(decoder: self.decoder) { (response : DataResponse<ResponseData<WheelHistoryList>>) in
            vc?.hideLoader()
            if let error = response.result.error {
                print(error.localizedDescription)
                onCompletion(error.localizedDescription,nil)

                return
            }
            //SUCCESS
            if response.result.value?.code == 200{
                //onCompletion(response.result.value?.message, response.result.value?.data?.wheel_history?.items)
                onCompletion(response.value?.message ?? "", response.result.value?.data?.wheel_history?.items)
                return
            }else{
                onCompletion(response.result.value?.message,nil)
                vc?.presentAlert(withTitle: "Error", andMessage: response.result.value?.message ?? MessageConstant.errorMessage)
            }
        }
    }
    
    //API for getting Items-List
    func getItemsList(params: Parameters,vc : UIViewController?, onCompletion: @escaping ItemsListResponseHandler) {
    
        vc?.showLoader()
        let request = self.postRequest(ApiName.item_list, parameters:params)
        mylog("getItemsList === \(baseURL)/\(ApiName.item_list) ||||||||||  params ===\(params)")
        request.responseDecodableObject(decoder: self.decoder) { (response : DataResponse<ResponseData<Items>>) in
            vc?.hideLoader()
            if let error = response.result.error {
                print(error.localizedDescription)
                onCompletion(error.localizedDescription,nil)
                vc?.presentAlert(withTitle: "Error", andMessage: error.localizedDescription)

                return
            }
            //SUCCESS
            if response.result.value?.code == 200{
                onCompletion(response.result.value?.message, response.result.value?.data)
                return
            }else{
                onCompletion(response.result.value?.message,nil)
                vc?.presentAlert(withTitle: "Error", andMessage: response.result.value?.message ?? MessageConstant.errorMessage)
            }
        }
    }
    
    //API for save game result.
    func saveGameResult(params: Parameters, vc : UIViewController?, onCompletion: @escaping CommonResponseHandler){
        vc?.showLoader()
        let request = self.postRequest(ApiName.saveScore, parameters:params)
        mylog("saveGameResult === \(baseURL)/\(ApiName.saveScore) ||||||||||  params ===\(params)")
        request.responseDecodableObject(decoder: self.decoder) { (response : DataResponse<ResponseData<String>>) in
            vc?.hideLoader()
            if let error = response.result.error {
                print(error.localizedDescription)
                onCompletion(false ,error.localizedDescription,nil)
                return
            }
            //SUCCESS
            if response.result.value?.code == 200{
                onCompletion(true ,response.result.value?.message, response.result.value?.data)
                vc?.presentAlert(withTitle: "Success", andMessage: MessageConstant.resultSavedSuccessfully)
                return
            }else{
                onCompletion(false,response.result.value?.message,nil)
                vc?.presentAlert(withTitle: "Error", andMessage: response.result.value?.message ?? MessageConstant.errorMessage)
            }
        }
    }
    
    //API for getting results List
    func getResultList(params: Parameters, vc : UIViewController?, onCompletion: @escaping ResultListResponseHandler) {
        vc?.showLoader()
        let request = self.postRequest(ApiName.score_list, parameters:params)
        mylog("getResultList === \(baseURL)/\(ApiName.score_list) ||||||||||  params ===\(params)")
        request.responseDecodableObject(decoder: self.decoder) { (response : DataResponse<ResponseData<GameResults>>) in
            vc?.hideLoader()
            if let error = response.result.error {
                print(error.localizedDescription)
                onCompletion(error.localizedDescription,nil)
                vc?.presentAlert(withTitle: "Error", andMessage: error.localizedDescription)
                return
            }

            if response.result.value?.code == 200{
                onCompletion(response.result.value?.message, response.result.value?.data)
                return
            }else{
                onCompletion(response.result.value?.message,nil)
                vc?.presentAlert(withTitle: "Error", andMessage: response.result.value?.message ?? MessageConstant.errorMessage)
            }
        }
        
    }
    
    
    //API for getting Game Results List....
    /*func getResultsList(params: Parameters, vc: UIViewController?, onCompletion: @escaping GameResultsResponseHandler) {
        
        let request = self.postRequest(ApiName.score_list, parameters:params)
        vc?.showLoader()
        request.responseDecodableObject(decoder: self.decoder) { (response : DataResponse<GameResultResponse>) in
            vc?.hideLoader()
            if let error = response.result.error {
                print(error.localizedDescription)
                onCompletion(error.localizedDescription,nil)
                vc?.presentAlert(withTitle: "Error", andMessage: error.localizedDescription)
                return
            }
            //SUCCESS
            if response.result.value?.code == 200{
                onCompletion(response.result.value?.message, response.result.value?.data)
                return
            }else{
                onCompletion(response.result.value?.message,nil)
                vc?.presentAlert(withTitle: "Error", andMessage: response.result.value?.message ?? "Something Went wrong.")
            }
        }
        
    }*/
    
    //API for Deleting Score....
    func deleteScore(params: Parameters, vc: UIViewController?, onCompletion: @escaping ScoreDeletedResponseHandler) {
        
        let request = self.postRequest(ApiName.delete_score, parameters:params)
        mylog("deleteScore === \(baseURL)/\(ApiName.delete_score) ||||||||||  params ===\(params)")
        vc?.showLoader()
        request.responseDecodableObject(decoder: self.decoder) { (response : DataResponse<ResponseData<String>>) in
            vc?.hideLoader()
            if let error = response.result.error {
                print(error.localizedDescription)
                onCompletion(error.localizedDescription)
                vc?.presentAlert(withTitle: "Error", andMessage: error.localizedDescription)
                return
            }
            //SUCCESS
            if response.result.value?.code == 200{
                onCompletion(response.result.value?.message)
                vc?.presentAlert(withTitle: "Success", andMessage: MessageConstant.scoreDeletedSuccessfully)
                return
            }else{
                onCompletion(response.result.value?.message)
                vc?.presentAlert(withTitle: "Error", andMessage: response.result.value?.message ?? MessageConstant.errorMessage)
            }
        }
        
    }
    
    
    //API for Updating Setting....
    func updateSetting(showAlert : Bool?, params: Parameters, vc : UIViewController?, onCompletion: @escaping CommonResponseHandler){
        vc?.showLoader()
        let request = self.postRequest(ApiName.update_settings, parameters:params)
        mylog("updateSetting === \(baseURL)/\(ApiName.update_settings) ||||||||||  params ===\(params)")
        request.responseDecodableObject(decoder: self.decoder) { (response : DataResponse<ResponseData<String>>) in
            vc?.hideLoader()
            if let error = response.result.error {
                print(error.localizedDescription)
                vc?.presentAlert(withTitle: "Error", andMessage: error.localizedDescription)
                onCompletion(false,error.localizedDescription,nil)
                return
            }
            //SUCCESS
            if response.result.value?.code == 200{
                onCompletion(true,response.result.value?.message, response.result.value?.data)
                if showAlert ?? false {
                    vc?.presentAlert(withTitle: "Success", andMessage: MessageConstant.settingUpdateSuccessfully)
                }
                return
            }else{
                onCompletion(false,response.result.value?.message,nil)
                vc?.presentAlert(withTitle: "Error", andMessage: response.result.value?.message ?? MessageConstant.errorMessage)
            }
        }
    }
    
    
    
    //API for Spent coin....
    func spentCoin(params: Parameters, vc : UIViewController?, onCompletion: @escaping CoinSpentResponseHandler){
        vc?.showLoader()
        let request = self.postRequest(ApiName.coin_spent, parameters:params)
        mylog("spentCoin === \(baseURL)/\(ApiName.coin_spent) ||||||||||  params ===\(params)")
        request.responseDecodableObject(decoder: self.decoder) { (response : DataResponse<ResponseData<CoinSpent>>) in
            vc?.hideLoader()
            if let error = response.result.error {
                print(error.localizedDescription)
                onCompletion(false, error.localizedDescription,nil)
                return
            }
            //SUCCESS
            if response.result.value?.code == 200{
                onCompletion(true, response.result.value?.message, response.result.value?.data)
                vc?.presentAlert(withTitle: "Success", andMessage: MessageConstant.coinSpentSuccessfully)
                return
            }else{
                onCompletion(false, response.result.value?.message,nil)
                vc?.presentAlert(withTitle: "Error", andMessage: response.result.value?.message ?? MessageConstant.errorMessage)
            }
        }
    }
    
    //API for update item...
    func updateItems(params: Parameters,vc : UIViewController? ,onCompletion: @escaping CommonResponseHandler) {
        
        vc?.showLoader()
        let request = self.postRequest(ApiName.update_item, parameters:params)
        mylog("updateItems === \(baseURL)/\(ApiName.update_item) ||||||||||  params ===\(params)")
        request.responseDecodableObject(decoder: self.decoder) { (response : DataResponse<ResponseData<String>>) in
            vc?.hideLoader()
            if let error = response.result.error {
                print(error.localizedDescription)
                onCompletion(false,error.localizedDescription,nil)
                vc?.presentAlert(withTitle: "Error", andMessage: error.localizedDescription)
                return
            }
            //SUCCESS
            if response.result.value?.code == 200{
                onCompletion(true,response.result.value?.message, response.result.value?.data)
                return
            }else{
                onCompletion(false,response.result.value?.message,nil)
                vc?.presentAlert(withTitle: "Error", andMessage: response.result.value?.message ?? MessageConstant.errorMessage)
            }
        }
    }
    
    
    
    //API for end game....
    func endgame(params: Parameters, vc : UIViewController?, onCompletion: @escaping CommonResponseHandler){
        vc?.showLoader()
        let request = self.postRequest(ApiName.end_game, parameters:params)
        mylog("endgame === \(baseURL)/\(ApiName.update_item) ||||||||||  params ===\(params)")
        request.responseDecodableObject(decoder: self.decoder) { (response : DataResponse<ResponseData<String>>) in
            vc?.hideLoader()
            if let error = response.result.error {
                print(error.localizedDescription)
                onCompletion(false,error.localizedDescription,nil)
                return
            }
            //SUCCESS
            if response.result.value?.code == 200{
                onCompletion(true,response.result.value?.message,response.result.value?.data)
                vc?.presentAlert(withTitle: "Success", andMessage: MessageConstant.gameEndSuccessfully)
                return
            }else{
                onCompletion(false,response.result.value?.message,response.result.value?.data)
                vc?.presentAlert(withTitle: "Error", andMessage: response.result.value?.message ?? MessageConstant.errorMessage)
            }
        }
    }
    
}


