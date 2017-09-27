import Cocoa
import Sparkle

private let defaults = UserDefaults.standard

final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
	let controller = IDETouchBarSimulatorHostWindowController.simulatorHostWindowController()!
	lazy var window: NSWindow = self.controller.window!
	lazy var toolbarView: NSView = self.window.toolbarView!

	func applicationWillFinishLaunching(_ notification: Notification) {
		defaults.register(defaults: [
			"NSApplicationCrashOnExceptions": true,
			"windowTransparency": 0.75
		])
	}

	func applicationDidFinishLaunching(_ notification: Notification) {
		NSApp.servicesProvider = self
		window.delegate = self

		_ = SUUpdater()

		toolbarView.addSubviews(
			makeScreenshotButton(),
			makeTransparencySlider()
		)
	}

	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		return true
	}

	func makeScreenshotButton() -> NSButton {
		let button = NSButton()
		button.image = #imageLiteral(resourceName: "ScreenshotButton")
		button.imageScaling = .scaleProportionallyDown
		button.isBordered = false
		button.bezelStyle = .shadowlessSquare
		button.frame = CGRect(x: toolbarView.frame.width - 19, y: 4, width: 16, height: 11)
		button.action = #selector(captureScreenshot)
		return button
	}

	func makeTransparencySlider() -> ToolbarSlider {
		let transparency = defaults.double(forKey: "windowTransparency")
		let slider = ToolbarSlider()
		slider.frame = CGRect(x: toolbarView.frame.width - 150, y: 4, width: 120, height: 11)
		slider.action = #selector(setTransparency)
		slider.minValue = 0.5
		slider.doubleValue = transparency
		window.alphaValue = CGFloat(transparency)
		return slider
	}

	@objc
	func captureScreenshot() {
		let KEY_6: CGKeyCode = 0x58
		pressKey(keyCode: KEY_6, flags: [.maskShift, .maskCommand])
	}

	@objc
	func setTransparency(sender: ToolbarSlider) {
		window.alphaValue = CGFloat(sender.doubleValue)
		defaults.set(sender.doubleValue, forKey: "windowTransparency")
	}

	@objc
	func toggleView(_ pboard: NSPasteboard, userData: String, error: NSErrorPointer) {
		window.setIsVisible(!window.isVisible)
	}
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
