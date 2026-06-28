/Author: [Michał Bystrzak] /

===========================
2.6. Partycjonowanie danych
===========================

Wprowadzenie
------------
Partycjonowanie to technika optymalizacji baz danych, polegająca na logicznym podziale jednej, ogromnej tabeli na mniejsze, fizyczne fragmenty nazywane partycjami. Z perspektywy aplikacji docelowej i użytkownika tabela wciąż zachowuje się jak spójna całość. Głównym celem tego zabiegu jest przyspieszenie zapytań (baza przeszukuje tylko konkretny fragment, a nie całość) oraz ułatwienie usuwania starych danych (zamiast powolnej operacji ``DELETE``, po prostu odpinasz i usuwasz całą partycję).

Partycjonowanie w PostgreSQL
----------------------------
PostgreSQL obsługuje natywne partycjonowanie deklaratywne. Oznacza to, że silnik sam zarządza przydziałem rekordów do odpowiednich partycji na podstawie ustalonych z góry reguł. Trzy główne metody to:

* **Zakresowe (RANGE):** Dzielenie danych np. po dacie (zlecenia z 2025 roku trafiają do jednej partycji, a z 2026 do drugiej).
* **Listowe (LIST):** Dzielenie po konkretnych wartościach (np. zlecenia o statusie "Zakończone" idą do jednej partycji, a "W trakcie" do innej).
* **Haszujące (HASH):** Matematyczne rozdzielenie danych na podstawie funkcji skrótu, by równomiernie obciążyć dyski serwera.

Partycjonowanie w SQLite
------------------------
W przeciwieństwie do PostgreSQL, lekki silnik SQLite **nie posiada** wbudowanego, natywnego mechanizmu partycjonowania. Wynika to z faktu, że jest to prosta baza plikowa.

Aby uzyskać efekt partycjonowania w SQLite, programista musi to zrobić ręcznie. Należy stworzyć kilka osobnych tabel fizycznych (np. ``zlecenia_2025``, ``zlecenia_2026``), a następnie połączyć je wspólnym widokiem (``VIEW``). Dodatkowo trzeba napisać specjalne wyzwalacze (``TRIGGERS INSTEAD OF``), które będą przechwytywać dane wstawiane do widoku i automatycznie kierować je do odpowiedniej pod-tabeli.
