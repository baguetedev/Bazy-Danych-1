#!/bin/bash

# Ustawienie ścieżki do Twojego projektu
PROJEKT_DIR="/home/student15/gitstuiff/Bazy-Danych-1"
cd "$PROJEKT_DIR" || exit

# Twój sprawdzony link do surowych danych CSV z Arkusza
LINK_CSV="https://docs.google.com/spreadsheets/d/e/2PACX-1vTq8qlrUea8l8lVkCEzqDy45oepDUm8kmL7hrploPt_suOFkJAK8uwGfodrXKy1XLm1kRHD9UflCw1Z/pub?gid=0&single=true&output=csv"

# Pobieramy aktualną listę od chłopaków
curl -s -L "$LINK_CSV" | sed 's/\r$//' > linki.csv

ZMIANY=0

# Czytamy plik (pomijamy nagłówek Numer,Link)
tail -n +2 linki.csv | while IFS=, read -r NUMER LINK; do
    # Czyścimy numer (wywalamy spacje i "2." na początku, żeby z "2.3" zostało "3")
    NUMER_CZYSTY=$(echo "$NUMER" | tr -d ' ' | sed 's/^2\.//')
    # Czyścimy link (wywalamy spacje i końcówki /)
    LINK_CZYSTY=$(echo "$LINK" | tr -d ' ' | sed 's/\/$//')

    if [ -n "$NUMER_CZYSTY" ] && [ -n "$LINK_CZYSTY" ]; then
        FOLDER="rozdzial_2${NUMER_CZYSTY}"
        SCIEZKA_SUBMODULU="source/rozdzial_2/${FOLDER}"

        # Sprawdzamy, czy już mamy tego submoduła
        if [ ! -d "$SCIEZKA_SUBMODULU" ]; then
            echo ">>> Wykryto nową osobę! Temat 2.$NUMER_CZYSTY: $LINK_CZYSTY"
            
            # Dodajemy submoduł do odpowiedniego folderu
            git submodule add "$LINK_CZYSTY" "$SCIEZKA_SUBMODULU"
            ZMIANY=1
        fi
    fi
done

# Jeśli doszedł ktoś nowy, naprawiamy spis treści i wysyłamy na GitHuba
if [ "$ZMIANY" -eq 1 ]; then
    echo ">>> Aktualizacja spisu treści (index.rst)..."
    
    # Tworzymy nagłówek spisu treści dla Rozdziału 2
    cat << 'EOF' > source/rozdzial_2/index.rst
Badania literaturowe
====================

.. toctree::
   :maxdepth: 1

EOF
    
    # Automatycznie dopisujemy wszystkie foldery rozdzial_2X do spisu
    # Sortujemy numerycznie, żeby 2.1 było przed 2.10
    for dir in $(ls -d source/rozdzial_2/rozdzial_2*/ | sort -V); do
        nazwa_folderu=$(basename "$dir")
        
        # Sprawdzamy, czy plik index.rst jest bezpośrednio, czy w podfolderze source/
        if [ -f "$dir/source/index.rst" ]; then
            echo "   $nazwa_folderu/source/index" >> source/rozdzial_2/index.rst
        else
            echo "   $nazwa_folderu/index" >> source/rozdzial_2/index.rst
        fi
    done
    
    # Wysyłamy zmiany do Twojego repozytorium głównego
    git add .
    git commit -m "Terminator: Automatycznie dodano nowe tematy z Arkusza"
    git push
    echo ">>> Sukces! Wszystko zaktualizowane na Twoim GitHubie."
else
    echo ">>> Brak nowych wpisów w Arkuszu. Kończę pracę."
fi
