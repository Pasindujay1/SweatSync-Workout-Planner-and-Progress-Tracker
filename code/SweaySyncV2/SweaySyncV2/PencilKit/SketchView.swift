import SwiftUI
import PencilKit

struct SketchView: UIViewRepresentable {
    @Binding var drawing: PKDrawing

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: SketchView

        init(_ parent: SketchView) {
            self.parent = parent
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.drawing = canvasView.drawing
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.delegate = context.coordinator
        canvas.tool = PKInkingTool(.pen, color: .black, width: 5)
        canvas.backgroundColor = .white
        canvas.isOpaque = true
        canvas.drawing = drawing
        canvas.alwaysBounceVertical = false
        canvas.drawingPolicy = .anyInput
        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // Do not overwrite the canvas's drawing on every update
        // SwiftUI will manage the binding automatically through delegate
    }
}
