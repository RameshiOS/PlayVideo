import SwiftUI
import AVKit
import WebKit

struct VideoPlayerView: UIViewControllerRepresentable {
    let url: URL
    let showControls: Bool
    let hideSeekBar: Bool

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: url)
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = showControls
       
        controller.requiresLinearPlayback = hideSeekBar
        controller.allowsPictureInPicturePlayback = true
        if hideSeekBar {
            player.play()
        }
        if #available(iOS 14.2, *) {
            controller.canStartPictureInPictureAutomaticallyFromInline = true
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
    
    func makeCoordinator() -> VideoPlayerCoordinator {
          return VideoPlayerCoordinator()
      }
}
class VideoPlayerCoordinator: NSObject {
    var player: AVPlayer?

    deinit {
        player?.pause()
    }
}
struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: VideoPlayerView(url: URL(string: "https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!, showControls: true, hideSeekBar: false)) {
                    Text("Play Remote Video (With Controls)")
                }
                NavigationLink(destination: VideoPlayerView(url: URL(string: "https://vimeo.com/347119375")!, showControls: true, hideSeekBar: true)) {
                    Text("Custom Video (No Seekbar)")
                }
                NavigationLink(destination: WebViewPlayer(url: URL(string: "https://vimeo.com/347119375")!)) {
                              Text("Play video in WebView")
                          }
            }
            .navigationBarTitle("Video List")
        }
    }
}


struct WebViewPlayer: View {
    let url: URL

    var body: some View {
        WebView(request: URLRequest(url: url))
    }
}

struct WebView: UIViewRepresentable {
    let request: URLRequest

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
