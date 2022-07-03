//
//  SotwithDD.swift
//  SwiftUIRenderingScenarios
//
//  Created by hoseung Lee on 2022/07/03.
//

import SwiftUI
import Combine

struct SotwithDD: View {
  @State var title = ""
  var body: some View {
    VStack {
      Text("Hello, World! \n \(title)")
      CustomProgressView(totalTime: "100")
      NavigationLink {
        SotwithDDDetailView(text: $title)
      } label: {
        Text("타이틀 수정하기")
      }
    }
  }
}

struct SotwithDDDetailView: View {
  @Binding var text: String
  var body: some View {
    TextField("수정하기", text: $text)
  }
}

struct SotwithDD_Previews: PreviewProvider {
  static var previews: some View {
    SotwithDD()
  }
}

struct CustomProgressView: View {
  @ObservedObject var viewModel: ViewModel
  var body: some View {
    VStack {
      Text(viewModel.totalTime)
      ProgressView(value: viewModel.currentProgress, total: 100)
        .progressViewStyle(.linear)
      .padding()
    }
  }

  init(totalTime: String) {
    self.viewModel = ViewModel(totalTime: totalTime)
  }
}
extension CustomProgressView {
  final class ViewModel: ObservableObject {
    @Published var totalTime = ""
    @Published var currentProgress: Double = 0
    private var cancellables = Set<AnyCancellable>()
    init(totalTime: String) {
      self.totalTime = totalTime
      Timer.publish(every: 0.5, on: .main, in: .default)
        .autoconnect()
        .sink { [unowned self] _ in
          guard currentProgress < 100 else { return }
          currentProgress += 1

        }
        .store(in: &cancellables)
    }
  }
}
