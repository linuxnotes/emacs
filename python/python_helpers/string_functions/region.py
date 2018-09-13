#coding: utf-8

"""
"""

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
