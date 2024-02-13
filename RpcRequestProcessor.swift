//
//  RpcRequestProcessor.swift
//  SafariExtensionWalletlibSwift
//
//  Created by Mike Sulistio on 2/12/24.
//

import Foundation
import SafariServices

@available(iOS 15.0, *)
public class RPCRequestProcessor {

    public init() {}
    
    // Update the callback type to include a way to send back a response
    public typealias RPCRequestHandler = (_ rpcMethod: String, _ completion: @escaping (RPCResponse) -> Void) -> Void

    public func processExtensionRequest(_ context: NSExtensionContext, callback: @escaping RPCRequestHandler) {
        guard let item = context.inputItems.first as? NSExtensionItem,
              let rawMessage = item.userInfo?[SFExtensionMessageKey],
              let message = rawMessage as? [String: Any],
              let method = message["method"] as? String else {
              print("Failed to deserialize JSON or missing 'method'")
            return;
        }
        
        // Call the callback with the parsed RPC request and a response callback
        callback(method) { response in
            // Here, you would serialize the response and use the NSExtensionContext to send it back
            self.completeWithResult(response, via: context)
        }
    }
    
    public static func parseRpcRequestParams<T: Codable>(_ context: NSExtensionContext, type: T.Type) -> T? {
        guard let item = context.inputItems.first as? NSExtensionItem,
              let rawMessage = item.userInfo?[SFExtensionMessageKey],
              let message = rawMessage as? [String: Any],
              let paramsJSON = message["params"] else {
            print("Failed to extract JSON data for parameters from context")
            return nil
        }

        do {
            // Convert paramsJSON back to Data for decoding
            let jsonData = try JSONSerialization.data(withJSONObject: paramsJSON, options: [])
            let decoder = JSONDecoder()
            let params = try decoder.decode(T.self, from: jsonData)
            return params
        } catch {
            print("Failed to decode parameters: \(error)")
            return nil
        }
    }

    private func completeWithResult(_ result: Codable, via context: NSExtensionContext) {
        do {
            // Serialize the result to JSON Data
            let jsonData = try JSONEncoder().encode(result)
            
            // Convert JSON Data to String
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                return
            }
            
            // Construct the userInfo dictionary with the JSON string
            let response = NSExtensionItem()
            response.userInfo = [
                SFExtensionMessageKey: [
                    "result": jsonString
                ]
            ]
            
            // Complete the request with the response
            context.completeRequest(returningItems: [response], completionHandler: nil)
            
        } catch {
            self.completeWithError(context, "Failed to encode result")
        }
    }
    
    private func completeWithError(_ context: NSExtensionContext, _ errorMessage: String) {
        let response = NSExtensionItem()
        response.userInfo = [
            SFExtensionMessageKey: [
                "error": [
                    "message": errorMessage
                ]
            ]
        ]
        
        context.completeRequest(returningItems: [response], completionHandler: nil)
    }
}
