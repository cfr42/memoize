.PHONY: texlua luatex clean

clean:
	-$(RM) -r mmz *.aux *.log main.pdf

texlua:
	texlua memoize-extract.lua

luatex:
	TEXMFCNF=".:" lualatex main.tex
