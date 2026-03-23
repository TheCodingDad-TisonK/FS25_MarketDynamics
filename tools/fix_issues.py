"""
fix_issues.py — two-shot fix:
  1. Convert icon.png → icon.dds with a valid uncompressed BGRA8 DDS header
  2. Inject missing input action l10n keys into all translation files
"""
import os, struct, glob, re
from PIL import Image

HERE    = os.path.dirname(os.path.abspath(__file__))
ROOT    = os.path.join(HERE, "..")
IMGDIR  = os.path.join(ROOT, "images")
TRANS   = os.path.join(ROOT, "translations")


# ──────────────────────────────────────────────────────────────────────────────
# 1.  icon.png  →  icon.dds   (valid uncompressed RGBA8)
# ──────────────────────────────────────────────────────────────────────────────

def write_dds(png_path, dds_path):
    img = Image.open(png_path).convert("RGBA").resize((512, 512), Image.LANCZOS)
    W, H = img.size

    # Swap R and B channels:  RGBA → BGRA  (DDS uncompressed layout)
    r, g, b, a = img.split()
    bgra = Image.merge("RGBA", (b, g, r, a))
    raw = bgra.tobytes()  # row-major, top-down

    pitch = W * 4

    # DDS_PIXELFORMAT  (32 bytes)
    ddpf = struct.pack("<IIIIIIII",
        32,           # dwSize
        0x41,         # dwFlags  DDPF_ALPHAPIXELS | DDPF_RGB
        0,            # dwFourCC
        32,           # dwRGBBitCount
        0x00FF0000,   # dwRBitMask
        0x0000FF00,   # dwGBitMask
        0x000000FF,   # dwBBitMask
        0xFF000000,   # dwABitMask
    )

    # DDSURFACEDESC2 header (124 bytes)
    flags = 0x100F   # DDSD_CAPS | DDSD_HEIGHT | DDSD_WIDTH | DDSD_PITCH | DDSD_PIXELFORMAT
    header = struct.pack("<IIIIIII",
        124,    # dwSize
        flags,  # dwFlags
        H,      # dwHeight
        W,      # dwWidth
        pitch,  # dwPitchOrLinearSize
        0,      # dwDepth
        0,      # dwMipMapCount
    )
    header += b'\x00' * 44           # dwReserved1[11]
    header += ddpf                   # 32 bytes
    header += struct.pack("<IIIII",
        0x1000, 0, 0, 0, 0           # dwCaps=DDSCAPS_TEXTURE, caps2/3/4/reserved2
    )
    assert len(header) == 124, f"Header length {len(header)} != 124"

    with open(dds_path, "wb") as f:
        f.write(b"DDS ")
        f.write(header)
        f.write(raw)

    kb = os.path.getsize(dds_path) // 1024
    print(f"[icon] Written {dds_path}  ({kb} KB)")


write_dds(
    os.path.join(IMGDIR, "icon.png"),
    os.path.join(IMGDIR, "icon.dds"),
)


# ──────────────────────────────────────────────────────────────────────────────
# 2.  Inject input action l10n keys into every translation file
# ──────────────────────────────────────────────────────────────────────────────

# Per-language text for the two action names.
# Keys: ISO code used in the filename (e.g. translation_de.xml → "de")
TRANSLATIONS = {
    "en": ("Open Market Screen",              "Create Futures Contract"),
    "de": ("Marktübersicht öffnen",            "Terminkontrakt erstellen"),
    "fr": ("Ouvrir la bourse",                 "Créer un contrat à terme"),
    "fc": ("Ouvrir la bourse",                 "Créer un contrat à terme"),   # Canadian FR
    "es": ("Abrir mercado",                    "Crear contrato de futuros"),
    "ea": ("Abrir mercado",                    "Crear contrato de futuros"),   # Latin-Am ES
    "it": ("Apri mercato",                     "Crea contratto futures"),
    "pt": ("Abrir mercado",                    "Criar contrato futuro"),
    "br": ("Abrir mercado",                    "Criar contrato futuro"),       # BR PT
    "pl": ("Otwórz rynek",                     "Utwórz kontrakt futures"),
    "cz": ("Otevřít trh",                      "Vytvořit futures kontrakt"),
    "ru": ("Открыть рынок",                    "Создать фьючерсный контракт"),
    "uk": ("Відкрити ринок",                   "Створити ф'ючерсний контракт"),
    "nl": ("Markt openen",                     "Futurescontract aanmaken"),
    "hu": ("Piac megnyitása",                  "Határidős szerződés létrehozása"),
    "tr": ("Piyasayı aç",                      "Vadeli işlem sözleşmesi oluştur"),
    "jp": ("市場を開く",                         "先物契約を作成"),
    "kr": ("시장 열기",                           "선물 계약 생성"),
    "da": ("Åbn markedet",                     "Opret futureskontrakt"),
    "id": ("Buka pasar",                       "Buat kontrak futures"),
    "no": ("Åpne markedet",                    "Opprett terminkontrakt"),
    "ro": ("Deschide piața",                   "Creează contract futures"),
    "sv": ("Öppna marknaden",                  "Skapa terminskontrakt"),
    "vi": ("Mở thị trường",                    "Tạo hợp đồng kỳ hạn"),
    "fi": ("Avaa markkinat",                   "Luo futuurisopimus"),
    "ct": ("開啟市場",                            "建立期貨合約"),               # Traditional Chinese
}

NEW_KEYS = ("input_MDM_MARKET_SCREEN", "input_MDM_CREATE_CONTRACT")

INJECT_BEFORE = "</texts>"

def inject_keys(xml_path, lang):
    ms_text, cc_text = TRANSLATIONS.get(lang, TRANSLATIONS["en"])
    block = (
        f'\n        <!-- Input action display names -->\n'
        f'        <text name="{NEW_KEYS[0]}" text="{ms_text}" />\n'
        f'        <text name="{NEW_KEYS[1]}" text="{cc_text}" />\n'
        f'    '
    )

    with open(xml_path, "r", encoding="utf-8") as f:
        content = f.read()

    if NEW_KEYS[0] in content:
        print(f"[l10n] {os.path.basename(xml_path)} — already has keys, skipping")
        return

    if INJECT_BEFORE not in content:
        print(f"[l10n] {os.path.basename(xml_path)} — cannot find injection point, skipping")
        return

    content = content.replace(INJECT_BEFORE, block + INJECT_BEFORE)

    with open(xml_path, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"[l10n] {os.path.basename(xml_path)} — injected")


for xml_path in sorted(glob.glob(os.path.join(TRANS, "translation_*.xml"))):
    fname = os.path.basename(xml_path)            # e.g. translation_de.xml
    lang  = fname.replace("translation_", "").replace(".xml", "")
    inject_keys(xml_path, lang)

print("\nDone.")
