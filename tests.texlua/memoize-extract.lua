#!/usr/bin/env texlua

-- This file is a part of Memoize, a TeX package for externalization of
-- graphics and memoization of compilation results in general, available at
-- https://ctan.org/pkg/memoize and https://github.com/sasozivanovic/memoize.
--
-- Copyright (c) 2025- TODO(all)
--
-- This work may be distributed and/or modified under the conditions of the
-- LaTeX Project Public License, either version 1.3c of this license or (at
-- your option) any later version.  The latest version of this license is in
-- https://www.latex-project.org/lppl.txt and version 1.3c or later is part of
-- all distributions of LaTeX version 2008 or later.
--
-- This work has the LPPL maintenance status `maintained'.
-- The Current Maintainer of this work is . TODO(all)
-- 
-- The files belonging to this work and covered by LPPL are listed in
-- <texmf>/doc/generic/memoize/FILES.

-- local VERSION = '2025/01/17 v1.4.1' -- TODO(all)

-- libraries already available due to the use of texlua
local lfs = require"lfs"
-- lfs:
--  lua-filesystem: used for checking/creating/deleting files/directories
--  see https://lunarmodules.github.io/luafilesystem/manual.html#reference
--  and https://texdoc.org/serve/LuaTeX/0
--
-- pdfe:
local pdfe = require"pdfe"
--  interface to pdf files: used to get information about a pdf file
--  see https://texdoc.org/serve/LuaTeX/0

if not lfs.isdir("mmz") then
	assert(lfs.mkdir("mmz"))
end

local pages = {}
local pdf = pdfe.open("testing-source.pdf")
for p in ("extract 1 extract 2 extract 4"):gmatch("%d+") do
	local p = assert(tonumber(p))
	local page = pdfe.getpage(pdf, p)
	if not page then
		print("warning page does not exist -> skipped")
	else
		local mediabox = pdfe.getbox(page, "MediaBox")
		-- TODO check this is the right interpretation of the mediabox
		print(("%sx%s +%s+%s"):format(mediabox[3], mediabox[4], mediabox[1], mediabox[2]))
		-- TODO check if this is the right size
		table.insert(pages, p)
	end
end
pdfe.close(pdf)

print(table.concat(pages, ","))
-- Be aware that using the %d syntax for -sOutputFile=... does not reflect the
-- page number in the original document. If you chose (for example) to process
-- even pages by using -sPageList=even, then the output of -sOutputFile=out%d.png
-- would still be out1.png, out2.png, out3.png etc.
print("exec", os.execute(([[rungs -sDEVICE=pdfwrite -dNOPAUSE -dQUIET -dBATCH -sPageList=%s -sOutputFile="mmz/testing-source-%%d.pdf" testing-source.pdf]]):format(
	table.concat(pages, ",")
)))
-- we can use the pages table for a mapping number in filename to pagenumber
-- TODO is a LUT in the other direction needed/handy?
