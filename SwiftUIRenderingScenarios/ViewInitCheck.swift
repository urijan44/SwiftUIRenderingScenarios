//
//  ViewInitCheck.swift
//  SwiftUIRenderingScenarios
//
//  Created by hoseung Lee on 2022/07/04.
//

import SwiftUI

struct ViewInitCheck: View {
  @State var text = ""
  @State var trackerNotification = ""
  var body: some View {
    VStack {
      TextField("텍스트 입력", text: $text)
      ViewInitTracker()
    }
  }
}

struct ViewInitTracker: View {
  var body: some View {
    Text("Some View")
  }

  init() {
    print("View init!!")
  }
}

struct ViewInitCheck_Previews: PreviewProvider {
  static var previews: some View {
    ViewInitCheck()
  }
}
