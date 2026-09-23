import AppKit

let width = 1024
let height = 500
let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: width,
    pixelsHigh: height, bitsPerSample: 8, samplesPerPixel: 4,
    hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB,
    bytesPerRow: 0, bitsPerPixel: 0)!
let context = NSGraphicsContext(bitmapImageRep: bitmap)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = context

NSColor(deviceRed: 48/255, green: 43/255, blue: 94/255, alpha: 1).setFill()
NSRect(x: 0, y: 0, width: width, height: height).fill()
NSColor(deviceRed: 69/255, green: 64/255, blue: 120/255, alpha: 0.75).setFill()
NSBezierPath(ovalIn: NSRect(x: -160, y: 250, width: 370, height: 370)).fill()
NSColor(deviceRed: 57/255, green: 52/255, blue: 109/255, alpha: 1).setFill()
NSBezierPath(ovalIn: NSRect(x: 720, y: -210, width: 470, height: 470)).fill()

let titleStyle: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 64, weight: .heavy),
    .foregroundColor: NSColor.white,
]
let subtitleStyle: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 30, weight: .medium),
    .foregroundColor: NSColor(deviceRed: 255/255, green: 183/255, blue: 131/255, alpha: 1),
]
("Kira Asistanım" as NSString).draw(at: NSPoint(x: 72, y: 265), withAttributes: titleStyle)
("Yeni kiranı kolayca hesapla" as NSString).draw(at: NSPoint(x: 76, y: 202), withAttributes: subtitleStyle)
let icon = NSImage(contentsOfFile: "artwork/icon-1024.png")!
icon.draw(in: NSRect(x: 685, y: 104, width: 292, height: 292))

context.flushGraphics()
NSGraphicsContext.restoreGraphicsState()
let data = bitmap.representation(using: .png, properties: [:])!
try data.write(to: URL(fileURLWithPath: "artwork/feature-1024x500.png"))
