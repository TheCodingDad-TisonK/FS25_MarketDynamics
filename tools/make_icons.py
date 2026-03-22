"""
MDM icon generator.
Produces:
  images/icon_source.png  — 512×512 source art (for fs25-icon treatment)
  images/menuIcon.dds     — 128×128 white-on-transparent for InGameMenu header
"""
from PIL import Image, ImageDraw
import math, struct, os

HERE   = os.path.dirname(os.path.abspath(__file__))
IMGDIR = os.path.join(HERE, "..", "images")
os.makedirs(IMGDIR, exist_ok=True)

# ──────────────────────────────────────────────────────────────────────────────
# Palette
# ──────────────────────────────────────────────────────────────────────────────
BG         = (10,  18,  36, 255)   # deep navy
GREEN      = (0,  210, 122, 255)   # MDM accent green
GREEN_DIM  = (0,  130,  76,  80)   # fill under chart
GRID       = (255,255,255,  18)    # very faint grid
WHITE      = (255,255,255,255)
WHITE_DIM  = (255,255,255,160)
GOLD       = (255,195,  55,255)
ARROW_UP   = (0,  210, 122,255)
RED        = (220, 60,  60,255)


def _aa_line(draw, x0, y0, x1, y1, color, width=3):
    """Draw a line with given integer width by offsetting."""
    for d in range(-(width//2), width//2 + 1):
        draw.line([(x0, y0+d), (x1, y1+d)], fill=color)
        draw.line([(x0+d, y0), (x1+d, y1)], fill=color)


def _dot(draw, cx, cy, r_outer, r_inner, col_outer, col_inner):
    draw.ellipse([cx-r_outer, cy-r_outer, cx+r_outer, cy+r_outer], fill=col_outer)
    draw.ellipse([cx-r_inner, cy-r_inner, cx+r_inner, cy+r_inner], fill=col_inner)


# ──────────────────────────────────────────────────────────────────────────────
# 512×512  ICON SOURCE  (mod-manager icon, before FS25 background is applied)
# ──────────────────────────────────────────────────────────────────────────────
W = H = 512
src = Image.new("RGBA", (W, H), (0, 0, 0, 0))
d   = ImageDraw.Draw(src, "RGBA")

# — dark rounded background —
d.rounded_rectangle([0, 0, W-1, H-1], radius=64, fill=BG)

# — chart bounds —
CX0, CY0 = 68,  400   # bottom-left
CX1, CY1 = 450, 110   # top-right

# — subtle grid lines —
for col_frac in [0.25, 0.50, 0.75]:
    gy = int(CY0 - col_frac * (CY0 - CY1))
    d.line([(CX0, gy), (CX1, gy)], fill=GRID, width=1)
for col_frac in [0.25, 0.50, 0.75]:
    gx = int(CX0 + col_frac * (CX1 - CX0))
    d.line([(gx, CY0), (gx, CY1)], fill=GRID, width=1)

# — price path (rising trend with realistic micro-dips) —
norms = [0.15, 0.30, 0.22, 0.40, 0.33, 0.52, 0.46, 0.63, 0.57, 0.72, 0.66, 0.80, 0.75, 0.90]
N = len(norms)

def chart_pt(i):
    t  = i / (N - 1)
    x  = CX0 + t * (CX1 - CX0)
    y  = CY0 - norms[i] * (CY0 - CY1)
    return x, y

pts = [chart_pt(i) for i in range(N)]

# filled glow under curve (layered transparency)
for alpha in [12, 20, 30]:
    poly = [(CX0, CY0)] + pts + [(pts[-1][0], CY0)]
    gfill = (GREEN[0], GREEN[1], GREEN[2], alpha)
    d.polygon(poly, fill=gfill)

# — candlestick-style bars at each point (subtle, behind the line) —
bar_w = int((CX1 - CX0) / (N - 1) * 0.28)
for i, (px, py) in enumerate(pts):
    # small OHLC-style body
    body_h = max(4, int((CY0 - py) * 0.12))
    bx     = int(px) - bar_w
    by_top = int(py) + 4
    by_bot = int(py) + body_h + 4
    is_up  = (i == 0) or (norms[i] >= norms[i-1])
    col    = (*GREEN[:3], 100) if is_up else (*RED[:3], 80)
    d.rectangle([bx, by_top, bx + bar_w*2, by_bot], fill=col)

# — chart line (3-pixel thick) —
for i in range(N - 1):
    x0, y0 = pts[i]
    x1, y1 = pts[i+1]
    for off in range(-2, 3):
        d.line([(x0, y0+off), (x1, y1+off)], fill=GREEN)

# — node dots —
for i, (px, py) in enumerate(pts):
    if i in (0, N//3, 2*N//3, N-1):
        _dot(d, int(px), int(py), 9, 5, GREEN, WHITE)

# — trend arrow (top-right, large) —
ax, ay = CX1 - 4, int(pts[-1][1])
# arrowhead pointing upper-right
arrow_pts = [
    (ax,      ay),
    (ax - 28, ay + 14),
    (ax - 12, ay + 6),
    (ax - 18, ay + 36),
    (ax - 4,  ay + 26),
    (ax + 10, ay + 44),
    (ax + 4,  ay + 12),
    (ax + 18, ay + 18),
]
d.polygon(arrow_pts, fill=ARROW_UP)

# — axis baseline —
d.line([(CX0, CY0), (CX1+10, CY0)], fill=(*WHITE[:3], 60), width=2)
d.line([(CX0, CY0+2), (CX0, CY1-10)], fill=(*WHITE[:3], 60), width=2)

# — small tick marks on Y axis —
for frac in [0.25, 0.50, 0.75, 1.0]:
    ty = int(CY0 - frac * (CY0 - CY1))
    d.line([(CX0-8, ty), (CX0, ty)], fill=(*WHITE[:3], 80), width=2)

# — "MARKET DYNAMICS" label at bottom —
# Render text as simple pixel blocks (no font needed, use rectangles for a monospace look)
# Actually just draw a small decorative bar instead
label_y = 445
bar_total = 320
d.rounded_rectangle([W//2 - bar_total//2, label_y, W//2 + bar_total//2, label_y+3],
                    radius=1, fill=(*GREEN[:3], 140))

# — small wheat-stalk silhouette (left side, subtle) —
# Simplified: just a few vertical strokes with dots
wh_x, wh_y = 36, 290
for i in range(5):
    sx = wh_x + i * 8
    d.line([(sx, wh_y), (sx, wh_y + 40)], fill=(*WHITE[:3], 30), width=2)
    d.ellipse([sx-4, wh_y-6, sx+4, wh_y+2], fill=(*GOLD[:3], 35))

out_source = os.path.join(IMGDIR, "icon_source.png")
src.save(out_source)
print(f"Saved: {out_source}")


# ──────────────────────────────────────────────────────────────────────────────
# 128×128  menuIcon.dds  — white-on-transparent for InGameMenu tab / header
# ──────────────────────────────────────────────────────────────────────────────
M = 128
menu = Image.new("RGBA", (M, M), (0, 0, 0, 0))
md   = ImageDraw.Draw(menu, "RGBA")

# Chart area
mcx0, mcy0 = 12,  110
mcx1, mcy1 = 116,  18

mnorms = [0.10, 0.28, 0.20, 0.42, 0.36, 0.55, 0.50, 0.70, 0.64, 0.82, 0.76, 0.94]
MN = len(mnorms)

def mchart_pt(i):
    t = i / (MN - 1)
    x = mcx0 + t * (mcx1 - mcx0)
    y = mcy0 - mnorms[i] * (mcy0 - mcy1)
    return x, y

mpts = [mchart_pt(i) for i in range(MN)]

# fill under curve
poly_m = [(mcx0, mcy0)] + mpts + [(mpts[-1][0], mcy0)]
md.polygon(poly_m, fill=(255, 255, 255, 30))

# line (2px white)
for i in range(MN - 1):
    x0, y0 = mpts[i]
    x1, y1 = mpts[i+1]
    for off in range(-1, 2):
        md.line([(x0, y0+off), (x1, y1+off)], fill=(255, 255, 255, 230))

# node dots at key points
for i in (0, MN//2, MN-1):
    px, py = mpts[i]
    md.ellipse([px-5, py-5, px+5, py+5], fill=(255, 255, 255, 240))
    md.ellipse([px-2, py-2, px+2, py+2], fill=(255, 255, 255, 255))

# small upward arrow at end
ex, ey = int(mpts[-1][0]), int(mpts[-1][1])
arw = [
    (ex,    ey),
    (ex-8,  ey+6),
    (ex-3,  ey+4),
    (ex-5,  ey+16),
    (ex+2,  ey+12),
    (ex+8,  ey+18),
    (ex+4,  ey+6),
    (ex+9,  ey+8),
]
md.polygon(arw, fill=(255, 255, 255, 220))

# baseline
md.line([(mcx0, mcy0), (mcx1, mcy0)], fill=(255, 255, 255, 100), width=2)

out_menu = os.path.join(IMGDIR, "menuIcon.dds")
menu.save(out_menu, format="DDS")
print(f"Saved: {out_menu}")

print("\nDone. Run fs25-icon skill on icon_source.png, then convert icon.png → icon.dds")
