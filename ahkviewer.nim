
import os
import strutils
import sequtils
import tables

const keylines* = [
  "1234567890-^\\",
  "qwertyuiop@[",
  "asdfghjkl;:]",
  "zxcvbnm,./\\",
]

proc keytableToString*(keytable: Table[string, string], space = "  ", indent = " "): string =
  var keystrings = newSeq[seq[string]]()
  for keyline in keylines:
    var keystring = newSeq[string]()
    for c in keyline:
      if keytable.hasKey($c):
        keystring.add(toUpperAscii(keytable[$c]))
      else:
        keystring.add(toUpperAscii($c))
    keystrings.add(keystring)
  result = ""
  var currindent = 0
  for keys in keystrings.mapIt(it.join(space)):
    result &= repeat(indent, currindent) & keys & "\n"
    currindent += 1

proc convertKey*(key: string): string =
  if key == "vkbasc028":
    ":"
  else:
    key

proc main() =
  if paramCount() < 1:
    quit "please choose script path. example: ahkviewer foo.ahk"
  let filename = paramStr(1)
  let src =readFile(filename)

  var keytable = initTable[string, string]()
  for line in src.split("\n"):
    let splitted = line.split("::")
    if splitted.len() != 2:
      continue
    let before = splitted[0].toLowerAscii()
    let after = splitted[1].toLowerAscii()
    keytable[before.convertKey()] = after.convertKey()
  echo "-- $# --" % $ filename
  echo keytableToString(keytable)

main()
