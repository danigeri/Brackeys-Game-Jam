@for /r %%f in (*.gd) do @echo Linting %%f && @gdlint "%%f"
