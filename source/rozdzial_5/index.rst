================================================
Rozdział 5: Zapytania do bazy danych
================================================

:Autorzy:
    1. Paweł Łoćwin
    2. Paweł Łosowski

Wstęp
=====
Niniejszy rozdział stanowi praktyczną realizację zadania polegającego na stworzeniu modułu funkcji w języku Python, które wykonują zaawansowane zapytania SQL do bazy danych bibliotecznego systemu zarządzania wypożyczeniami.

Opracowane rozwiązanie obejmuje:

1. **Kompleksowy moduł w Pythonie** – zawierający 10 zaawansowanych zapytań (każde zaimplementowane w wariancie dla PostgreSQL i SQLite).
2. **Zaawansowane techniki SQL** – realizujące m.in. selekcje, agregacje, złączenia wielotabelowe, operatory zbiorowe oraz podzapytania (w tym CTE i okna funkcji).
3. **Środowisko interaktywne** – weryfikacja i testowanie zapytań z wykorzystaniem notatników w JupyterLab.
4. **Zarządzanie bezpieczeństwem** – pełna parametryzacja zapytań chroniąca przed atakami typu SQL Injection.

Przegląd zaimplementowanej logiki biznesowej
===========================================
Zamiast banalnych zapytań typu `SELECT *`, zaimplementowano złożone scenariusze odpowiadające realnym potrzebom systemu bibliotecznego. Każde z zapytań występuje w dwóch optymalizowanych wersjach (dla silnika PostgreSQL oraz SQLite). 

Zestawienie analityczne zapytań:

* **Analiza aktywności (Złączenia i Agregacje):** Identyfikacja najaktywniejszych czytelników oraz zestawienie autorów wraz z liczbą ich publikacji i datą debiutu (wykorzystanie ``GROUP BY``, ``HAVING``, ``LEFT JOIN``).
* **Statystyki zasobów (Funkcje wierszowe i agregujące):** Szczegółowe statystyki kategorii książek, w tym średni rok wydania i współczynnik popularności poszczególnych działów (wykorzystanie ``AVG()``, ``COUNT()``, ``NULLIF``).
* **Katalogowanie i historia (Złączenia wielokrotne):** Generowanie pełnego katalogu książek z uwzględnieniem statusu dostępności oraz pełnej, chronologicznej historii wypożyczeń konkretnego czytelnika (potrójne złączenia ``LEFT JOIN``, ``COALESCE()``).
* **Audyt bazy (Operatory zbiorowe):** Wyszukiwanie czytelników będących jednocześnie autorami (``UNION``, ``EXISTS``) oraz identyfikacja woluminów, które nigdy nie zostały wypożyczone (``NOT IN``, subqueries).
* **Zaawansowana analityka czasowa (CTE i Podzapytania):** Zestawienie książek wypożyczanych częściej niż wynosi średnia biblioteki oraz kwartalna analiza trendów wypożyczeń (wykorzystanie okien funkcji ``LAG``, ``EXTRACT``, ``WITH ... AS``).

Przewodnik po złożoności zapytań SQL
====================================
Poniższa tabela podsumowuje zagadnienia teoretyczne zrealizowane w poszczególnych kwerendach:

.. list-table::
   :header-rows: 1
   :widths: 10, 15, 15, 15, 15, 15

   * - Query
     - Selekcja
     - Agregacja
     - Złączenia
     - Operatory
     - Zaawansowane
   * - Query 1
     - ✓
     - COUNT, MIN, UPPER
     - LEFT JOIN
     - GROUP BY, HAVING
     - Funkcje wierszowe
   * - Query 2
     - ✓
     - COUNT, MAX
     - INNER JOIN
     - WHERE IS NULL
     - Obliczenia dat
   * - Query 3
     - ✓
     - COUNT, AVG, ROUND
     - 3× LEFT JOIN
     - GROUP BY, HAVING
     - NULLIF, Triple JOIN
   * - Query 4
     - ✓
     - COUNT (×2)
     - INNER JOIN
     - GROUP BY
     - LIMIT, Ranking
   * - Query 5
     - ✓
     - COUNT (warunkowy)
     - 3× LEFT JOIN
     - COALESCE
     - CASE WHEN
   * - Query 6
     - ✓
     - -
     - 2× INNER JOIN
     - WHERE z parametrem
     - Parametryzacja
   * - Query 7
     - ✓
     - -
     - EXISTS
     - UNION
     - Operatory zbiorowe
   * - Query 8
     - ✓
     - COUNT (DISTINCT)
     - LEFT JOIN
     - NOT IN
     - Podzapytanie
   * - Query 9
     - ✓
     - COUNT, AVG
     - LEFT JOIN
     - WITH, HAVING
     - CTE, Podzapytanie
   * - Query 10
     - ✓
     - COUNT
     - -
     - EXTRACT
     - LAG, Okna funkcji

Środowisko testowe i wdrożenie
==============================
Przed osadzeniem kodu w module, zapytania były weryfikowane interaktywnie.

**Lokalizacja środowiska roboczego:**
Ścieżka dostępu na serwerze programuję.eu:

.. code-block:: text

    /var/www/projekty/baguetedev/Bazy-Danych-1/modules/db_queries.py

**Przykładowe wywołanie w JupyterLab:**

.. code-block:: python

    import sys
    sys.path.insert(0, '/var/www/projekty/baguetedev/Bazy-Danych-1')
    from modules.db_queries import *
    
    # Konfiguracja PostgreSQL
    pg_config = {
        'host': 'localhost',
        'dbname': 'biblioteka',
        'user': 'postgres',
        'password': 'haslo'
    }
    
    # Wywołanie przykładowej funkcji z parametrem
    reader_id = 1
    history = query_6_historia_wypozyczen_czytelnika_postgres(pg_config, reader_id)
    for book in history:
        print(f"{book['tytul']} - Status: {book['status']}")

Wszystkie funkcje w module automatycznie zarządzają połączeniami poprzez context managery (``with``) oraz implementują bloki ``try-except``, co gwarantuje stabilność działania. Kod modułu dostępny jest w repozytorium: `baguetedev/Bazy-Danych-1 <https://github.com/baguetedev/Bazy-Danych-1/blob/main/modules/db_queries.py>`_.

Dokumentacja interfejsu programistycznego (API)
===============================================
Poniższa dokumentacja techniczna została wygenerowana automatycznie z docstringów modułu ``db_queries.py`` przy użyciu dyrektywy ``automodule`` frameworka Sphinx. Gwarantuje to spójność opisu z faktycznie zaimplementowanym kodem źródłowym (Single Source of Truth).

.. automodule:: modules.db_queries
   :members:
   :undoc-members:
   :show-inheritance:
