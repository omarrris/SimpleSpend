import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    private(set) var localRealm: Realm?
    @Published var expenses: [Expense] = []
    @Published var categories: [Category] = []
    
    init() {
        openRealm()
        loadExpenses()
        loadCategories()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = config
            localRealm = try Realm()
        } catch {
            print("Error opening Realm", error)
        }
    }
    
    func loadExpenses() {
        if let localRealm = localRealm {
            let allExpenses = localRealm.objects(Expense.self).sorted(byKeyPath: "date")
            expenses = Array(allExpenses)
        }
    }
    
    func submitExpense(_ expense: Expense) throws {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    localRealm.add(expense)
                    loadExpenses()
                    print("Expense submitted to Realm!", expense)
                }
            } catch {
                print("Error submitting expense to Realm: \(error)")
                throw error
            }
        }
    }
    
    func loadCategories() {
        if let localRealm = localRealm {
            let allCategories = localRealm.objects(Category.self)
            categories = Array(allCategories)
        }
    }
    
    func submitCategory(_ category: Category) throws {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    localRealm.add(category)
                    loadCategories()
                    print("Category submitted to Realm!", category)
                }
            } catch {
                print("Error submitting category to Realm: \(error)")
                throw error
            }
        }
    }
    
    func deleteCategory(category: Category) throws {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    localRealm.delete(category)
                    loadCategories()
                    print("Category deleted from Realm!", category)
                }
            } catch {
                print("Error deleting category to Realm: \(error)")
                throw error
            }
        }
    }
}
