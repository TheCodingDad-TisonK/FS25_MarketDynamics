#!/usr/bin/env python3
"""
MDM translation generator.
Reads strings from translations/translation_en.xml and produces
one translation_XX.xml per FS25 language via Google Translate.
"""

import os, sys, xml.etree.ElementTree as ET
from pathlib import Path

try:
    from deep_translator import GoogleTranslator
except ImportError:
    print("Installing deep-translator...")
    os.system(f"{sys.executable} -m pip install deep-translator")
    from deep_translator import GoogleTranslator

LANGUAGES = {
    "de": "de",   "fr": "fr",   "fc": "fr",   "es": "es",   "ea": "es",
    "it": "it",   "pt": "pt",   "br": "pt",   "pl": "pl",   "cz": "cs",
    "ru": "ru",   "uk": "uk",   "nl": "nl",   "hu": "hu",   "tr": "tr",
    "jp": "ja",   "kr": "ko",   "da": "da",   "id": "id",   "no": "no",
    "ro": "ro",   "sv": "sv",   "vi": "vi",   "fi": "fi",   "ct": "zh-TW",
}

MOD_ROOT  = Path(__file__).parent
TRANS_DIR = MOD_ROOT / "translations"
EN_FILE   = TRANS_DIR / "translation_en.xml"

if not EN_FILE.exists():
    print(f"ERROR: {EN_FILE} not found"); sys.exit(1)

# Parse English source
tree = ET.parse(EN_FILE)
strings = {}   # key -> english text
for t in tree.getroot().findall(".//text"):
    name = t.get("name", "")
    text = t.get("text", "")
    if name and text:
        strings[name] = text

print(f"Found {len(strings)} strings in translation_en.xml\n")

def xml_escape(s):
    s = s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace('"', "&quot;")
    return s

def write_file(lang_code, translated):
    path = TRANS_DIR / f"translation_{lang_code}.xml"
    lines = ['<?xml version="1.0" encoding="utf-8" standalone="no"?>', "<l10n>", "    <texts>", ""]
    for key, val in translated.items():
        lines.append(f'        <text name="{key}" text="{xml_escape(val)}"/>')
    lines += ["", "    </texts>", "</l10n>"]
    path.write_text("\n".join(lines), encoding="utf-8")

def translate_batch(google_lang):
    out = {}
    translator = GoogleTranslator(source="en", target=google_lang)
    items = list(strings.items())
    for i, (key, val) in enumerate(items, 1):
        try:
            result = translator.translate(val)
            out[key] = result if result else val
        except Exception as e:
            print(f"  WARNING [{key}]: {e}")
            out[key] = val
        if i % 10 == 0 or i == len(items):
            print(f"  {i}/{len(items)}", end="\r")
    print()
    return out

for fs_code, google_code in LANGUAGES.items():
    print(f"[{fs_code.upper()}] {google_code}...")
    try:
        translated = translate_batch(google_code)
        write_file(fs_code, translated)
        print(f"  Written: translation_{fs_code}.xml")
    except Exception as e:
        print(f"  ERROR: {e}")

print("\nDone.")
