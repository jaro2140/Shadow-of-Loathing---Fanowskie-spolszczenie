## Paczki release

Ten katalog docelowo zawiera wyłącznie gotowe archiwa ZIP przeznaczone do
publikacji w GitHub Releases. Nie dzielimy go na podkatalogi w repozytorium —
binaria trafiają tu tylko lokalnie i nie są commitowane (zbyt duże na git),
tylko wgrywane ręcznie jako załącznik do wydania.

Po rozpakowaniu archiwum bundle musi znajdować się w podkatalogu z nazwą
platformy, na przykład:

```text
patches/
  steamos-proton/
    core
    platform.txt
    source-sha256.txt
```

Instalator sprawdza `platform.txt` przed podmianą plików gry i przerwie
działanie, jeśli otrzyma bundle zbudowany dla innej platformy. Nie wolno
używać plików z paczki innej platformy — to psuje instalację.

Gotową paczkę, gdy się pojawi, należy pobrać z zakładki
[**Releases**](../../../releases).
