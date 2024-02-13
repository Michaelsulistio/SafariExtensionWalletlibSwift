import Foundation

public protocol RPCRequest: Codable {
    var method: String { get }
    var params: Codable { get }
}

public protocol RPCResponse: Codable {
    var result: Codable? { get };
    var error: RPCError? { get };
}

public protocol RPCError: Codable {
    var message: String { get }
}

public enum RPCMethod: String {
    case getAccountsMethod = "NATIVE_GET_ACCOUNTS_RPC_METHOD"
    case signTransactionsMethod = "NATIVE_SIGN_TRANSACTIONS_RPC_METHOD"
    case signMessagesMethod = "NATIVE_SIGN_MESSAGES_RPC_METHOD"
    case signPayloadsMethod = "NATIVE_SIGN_PAYLOADS_RPC_METHOD"
}



// MARK: - Get Accounts

public struct NativeGetAccountsParams: Codable {
    let extra_data: [String: String]?
}

public struct NativeGetAccountsResult: Codable {
    let addresses: [String] // Assuming Base58EncodedAddress is a base58-encoded string
}

// MARK: - Sign Transaction

public struct NativeSignTransactionParams: Codable {
    let address: String // Base64EncodedAddress
    let transaction: String // Base64EncodedTransaction
    let extra_data: [String: String]?
}

public struct NativeSignTransactionResult: Codable {
    let signed_transactions: [String] // Assuming Uint8Array is a base64-encoded string
}

// MARK: - Sign Messages

public struct NativeSignMessagesParams: Codable {
    let address: String // Base64EncodedAddress
    let messages: [String] // Base64EncodedMessage
    let extra_data: [String: String]?
}

public struct NativeSignMessagesResult: Codable {
    let signed_messages: [String] // Assuming Uint8Array is a base64-encoded string
}

// MARK: - Sign Payloads

public struct NativeSignPayloadsParams: Codable {
    let address: String // Base64EncodedAddress
    let payloads: [String] // Base64EncodedPayload
    let extra_data: [String: String]?
}

public struct NativeSignPayloadsResult: Codable {
    let signed_payloads: [String] // Assuming Uint8Array is a base64-encoded string
}
