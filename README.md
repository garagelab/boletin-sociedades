# Boletín Oficial – Segunda Sección

Proyecto para analizar el contenido de la Segunda Sección del Boletín
Oficial de la República Argentina.

# Uso

## 1. Bajarse los PDF

El comando `fetch` baja los PDF de las tres secciones del BO para
cada día.  Comienza del día de hoy hacia atrás. Se puede cortar en
cualquier momento (Ctrl-C) y al correrlo nuevamente arranca desde donde
dejó.

    $ ./bin/fetch

## 2. Cargar la base de datos de nombres

La extracción de nombres que hacemos utiliza una base de datos de
nombres.  Para evitar cargar en memoria esta base cada vez que se corre
el programa, hacemos un prellenado en Redis. (No es ideal, pero si a
alguien se le ocurre algo mejor, que avise.)

Este proceso se corre una sola vez.

    $ rake names

## 3. Correr el parser

El comando `parse` lee _standard input_ y extrae nombres de sociedades y
personas.  Para pasar el PDF a texto, utilizamos `pdftotext` (provisto
por el paquete `poppler` o `poppler-utils`).

Para procesar un solo día:

    $ pdftotext -raw 20120210-02.pdf - | ./bin/parse

Para muchos días:

    $ find . -name '*-02.pdf' | while read file; do pdftotext -raw "$file" - | ./bin/parse; done

# Desarrollo

¡Hay tests!

    $ rake

Para agregar funcionalidad y corregir bugs, por favor reproducir los
casos en los tests, así no rompemos nada a futuro.
