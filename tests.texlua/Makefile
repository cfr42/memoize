.PHONY: texlua luatex clean

clean:
	-$(RM) -r mmz *.aux *.log *.pdf

texlua:
	texlua memoize-extract.lua

luatex:
	lualatex main.tex
