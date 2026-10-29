"""Generate the EW Compats logo and icon (white on black) as PNG, and the black icon and favicon of the docs.

Usage: python tools/generate_logo.py
Then convert with: hemtt utils paa convert img/<name>.png img/<name>.paa
"""
import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

OUT = Path(__file__).resolve().parent.parent / "img"
DOCS = Path(__file__).resolve().parent.parent / "docs"
YELLOW = (255, 214, 77)  # Zitronengelb, the brand color of the docs header
INK = (0, 0, 0)
FONT = "C:/Windows/Fonts/bahnschrift.ttf"
SS = 4  # supersampling factor
W, B = 255, 0


def mark(size, ring=True):
    """Antenna with signal arcs, struck through by a jamming zigzag. Returns an 'L' image."""
    s = size * SS
    img = Image.new("L", (s, s), B)
    d = ImageDraw.Draw(img)
    c = s / 2
    u = s / 100  # 1 unit = 1% of the canvas

    if ring:
        d.ellipse([c - 47 * u, c - 47 * u, c + 47 * u, c + 47 * u], outline=W, width=round(3.2 * u))

    # antenna mast + base + head
    hy = c - 14 * u
    bot = c + 30 * u
    d.line([(c, hy), (c, bot)], fill=W, width=round(4 * u))
    d.polygon([(c - 11 * u, bot), (c + 11 * u, bot), (c, bot - 10 * u)], fill=W)
    hr = 5 * u
    d.ellipse([c - hr, hy - hr, c + hr, hy + hr], fill=W)

    # signal arcs either side of the antenna head
    for r in (13, 21, 29):
        rr = r * u
        box = [c - rr, hy - rr, c + rr, hy + rr]
        for a0, a1 in ((-45, 45), (135, 225)):
            d.arc(box, a0, a1, fill=W, width=round(3.2 * u))

    # jamming zigzag, kept inside the ring: black knock-out first, white bolt on top
    pts = [(-36, 14), (-21, 6), (-10, 19), (3, 0), (14, 13), (36, -4)]
    pts = [(c + x * u, c + y * u) for x, y in pts]
    d.line(pts, fill=B, width=round(9 * u), joint="curve")
    d.line(pts, fill=W, width=round(3.6 * u), joint="curve")
    for p in (pts[0], pts[-1]):
        d.ellipse([p[0] - 1.8 * u, p[1] - 1.8 * u, p[0] + 1.8 * u, p[1] + 1.8 * u], fill=W)

    # trim anything outside the ring
    mask = Image.new("L", (s, s), 0)
    ImageDraw.Draw(mask).ellipse([c - 48 * u, c - 48 * u, c + 48 * u, c + 48 * u], fill=255)
    img = Image.composite(img, Image.new("L", (s, s), B), mask)
    return img.resize((size, size), Image.LANCZOS)


def logo(w, h):
    img = Image.new("L", (w, h), B)
    d = ImageDraw.Draw(img)
    m = mark(round(h * 0.56))
    f1 = ImageFont.truetype(FONT, round(h * 0.17))
    f2 = ImageFont.truetype(FONT, round(h * 0.048))
    t1, t2 = "EW COMPATS", "ELECTRONIC WARFARE COMPATIBILITY"
    # stretch the subtitle to the title width with letter spacing
    tw = d.textlength(t1, font=f1)
    sp = (tw - d.textlength(t2, font=f2)) / (len(t2) - 1)
    gap = round(h * 0.07)
    x = round((w - (m.width + gap + tw)) / 2)
    img.paste(m, (x, (h - m.height) // 2))
    x0 = x + m.width + gap
    cy = h / 2
    d.text((x0, cy + h * 0.02), t1, font=f1, fill=W, anchor="ls")
    d.line([(x0, cy + h * 0.055), (x0 + tw, cy + h * 0.055)], fill=W, width=max(2, round(h * 0.006)))
    cx = x0
    for ch in t2:
        d.text((cx, cy + h * 0.13), ch, font=f2, fill=W, anchor="ls")
        cx += d.textlength(ch, font=f2) + sp
    return img


def docs_assets():
    """Docs header is yellow, so the mark is black there. The favicon sits on a yellow disc to be seen on any tab color."""
    m = mark(256)
    Image.merge("RGBA", tuple(Image.new("L", m.size, c) for c in INK) + (m,)).save(DOCS / "icon.png")

    size = 256 * SS
    disc = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    ImageDraw.Draw(disc).ellipse([0, 0, size - 1, size - 1], fill=YELLOW + (255,))
    disc = disc.resize((256, 256), Image.LANCZOS)
    disc.alpha_composite(Image.open(DOCS / "icon.png"))
    disc.save(DOCS / "favicon.png")


if __name__ == "__main__":
    OUT.mkdir(exist_ok=True)
    # in-game icon: white mark, transparent background (luminance becomes alpha)
    m = mark(256)
    Image.merge("RGBA", (Image.new("L", m.size, W),) * 3 + (m,)).save(OUT / "icon_ca.png")
    mark(512).convert("RGB").save(OUT / "icon_512.png")
    logo(2048, 1024).convert("RGB").save(OUT / "logo_ca.png")
    docs_assets()
