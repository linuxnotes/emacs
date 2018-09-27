#coding: utf-8

"""
"""
import re

def table2json(text):
    """
    """
    text = text.split("\n")
    keys = []
    prop = None
    for i in text:
        j = i.split(':')
        keys.append(j[1].strip())
        prop = j[0].strip()
    keys = map(lambda x: '"%s"' % x, keys)
    new_text = """"%s": [\n%s]"""% (prop, ",\n".join(keys))
    return new_text

def swap_assignment_line(text):
    """ p1 = p2 -> p2 = p1
    """
    text = text.split("=")
    p1 = text[0]
    p2 = text[1]
    indent = re.match(r"\s*", p1).group()
    p1 = p1.strip();
    after =  re.match(r".*\S(\s*)", p2)
    after_indent = ""
    if after != None:
        after_indent = after.group(1)
    p2 = p2.strip()
    new_text = indent + p2 + " = " + p1 + after_indent
    return new_text

