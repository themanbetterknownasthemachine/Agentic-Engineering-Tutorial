"""Smoke-Test: haelt die Test-Suite lauffaehig, bis echte Tests existieren.

Ersetzen, sobald das Projekt eigene Tests hat. Nicht loeschen, ohne
etwas Besseres an die Stelle zu setzen - eine leere Suite laesst
pytest mit Exit-Code 5 fehlschlagen und verify.sh rot werden.
"""


def test_smoke() -> None:
    assert True
