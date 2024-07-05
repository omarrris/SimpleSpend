import SwiftUI
import RealmSwift

struct Categories: View {
   @EnvironmentObject var realmManager: RealmManager
   
   @State private var invalidDataAlertShowing = false
   @State private var newCategoryName: String = ""
   @State private var newCategoryColor = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
   @State private var errorMessage: String = ""
   @State private var showErrorAlert = false
   
   func handleSubmit() {
       if newCategoryName.count > 0 {
           do {
               try self.realmManager.submitCategory(Category(
                   name: newCategoryName,
                   color: newCategoryColor
               ))
               newCategoryName = ""
           } catch {
               errorMessage = "Failed to submit category: \(error.localizedDescription)"
               showErrorAlert = true
           }
       } else {
           invalidDataAlertShowing = true
       }
   }
   
   func handleDelete(at offsets: IndexSet) {
       if let index = offsets.first {
           do {
               try realmManager.deleteCategory(category: realmManager.categories[index])
           } catch {
               errorMessage = "Failed to delete category: \(error.localizedDescription)"
               showErrorAlert = true
           }
       }
   }
   
   var body: some View {
       VStack {
           List {
               ForEach(realmManager.categories, id: \.name) { category in
                   HStack {
                       Circle()
                           .frame(width: 12)
                           .foregroundColor(category.color)
                       Text(category.name)
                   }
               }
               .onDelete(perform: handleDelete)
           }
           
           Spacer()
           
           HStack(spacing: 16) {
               ColorPicker("", selection: $newCategoryColor, supportsOpacity: false)
                   .labelsHidden()
                   .accessibilityLabel("")
               
               ZStack(alignment: .trailing) {

                   TextField("New category", text: $newCategoryName)
                       .textFieldStyle(.roundedBorder)
                       .submitLabel(.done)
                       .onSubmit {
                           handleSubmit()
                       }
                   
                   if newCategoryName.count > 0 {
                       Button {
                           newCategoryName = ""
                       } label: {
                           Label("Clear input", systemImage: "xmark.circle.fill")
                               .labelStyle(.iconOnly)
                               .foregroundColor(.gray)
                               .padding(.trailing, 6)
                       }
                   }
               }
               
               Button {
                   handleSubmit()
               } label: {
                   Label("Submit", systemImage: "paperplane.fill")
                       .labelStyle(.iconOnly)
                       .padding(6)
               }
               .background(.blue)
               .foregroundColor(.white)
               .cornerRadius(6)
               .alert("Must provide a category name!", isPresented: $invalidDataAlertShowing) {
                   Button("OK", role: .cancel) {
                       invalidDataAlertShowing = false
                   }
               }
               .alert(isPresented: $showErrorAlert) {
                   Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
               }
           }
           .padding(.horizontal, 16)
           .padding(.bottom, 16)
           .navigationTitle("Categories")
       }
       .padding(.top, 16)
       .toolbar {
           ToolbarItemGroup(placement: .keyboard) {
               Spacer()
               Button {
                   hideKeyboard()
               } label: {
                   Label("Dismiss", systemImage: "keyboard.chevron.compact.down")
               }
           }
       }
   }
}

struct Categories_Previews: PreviewProvider {
   static var previews: some View {
       Categories()
   }
}
