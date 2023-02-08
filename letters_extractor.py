import freetype, sys
stdout = open(1, mode="w", encoding="utf8")
face = freetype.Face(sys.argv[1])
stdout.write("".join(sorted([chr(c) for c, g in face.get_chars() if c]) + ["\n"]))