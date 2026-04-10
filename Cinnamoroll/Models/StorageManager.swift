import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private let transactionsKey = "transactions"
    private let categoriesKey = "categories"
    
    private init() {}
    
    // MARK: - Transactions
    func saveTransactions(_ transactions: [Transaction]) {
        if let data = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(data, forKey: transactionsKey)
        }
    }
    
    func loadTransactions() -> [Transaction] {
        guard let data = UserDefaults.standard.data(forKey: transactionsKey),
              let transactions = try? JSONDecoder().decode([Transaction].self, from: data) else {
            return []
        }
        return transactions
    }
    
    // MARK: - Categories
    func saveCategories(_ categories: [Category]) {
        if let data = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(data, forKey: categoriesKey)
        }
    }
    
    func loadCategories() -> [Category] {
        guard let data = UserDefaults.standard.data(forKey: categoriesKey),
              let categories = try? JSONDecoder().decode([Category].self, from: data) else {
            return Category.defaultCategories
        }
        return categories
    }
}