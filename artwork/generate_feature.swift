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

NSColor(deviceRed: 71/255, green: 59/255, blue: 131/255, alpha: 1).setFill()
NSRect(x: 0, y: 0, width: width, height: height).fill()

let titleStyle: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 64, weight: .bold),
    .foregroundColor: NSColor.white,
]
let subtitleStyle: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 30, weight: .medium),
    .foregroundColor: NSColor(calibratedRed: 1, green: 0.75, blue: 0.59, alpha: 1),
]
("Kira Asistanım" as NSString).draw(at: NSPoint(x: 72, y: 278), withAttributes: titleStyle)
("Yeni kiranı kolayca hesapla" as NSString).draw(at: NSPoint(x: 76, y: 218), withAttributes: subtitleStyle)
NSColor(deviceRed: 1, green: 0.99, blue: 0.97, alpha: 1).setFill()
NSBezierPath(ovalIn: NSRect(x: 685, y: 105, width: 290, height: 290)).fill()
let symbolStyle: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 210, weight: .bold),
    .foregroundColor: NSColor(deviceRed: 71/255, green: 59/255, blue: 131/255, alpha: 1),
]
("₺" as NSString).draw(at: NSPoint(x: 762, y: 135), withAttributes: symbolStyle)

context.flushGraphics()
NSGraphicsContext.restoreGraphicsState()
let data = bitmap.representation(using: .png, properties: [:])!
try data.write(to: URL(fileURLWithPath: "artwork/feature-1024x500.png"))
