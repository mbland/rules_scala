"""Utilities for converting values for use in BUILD files"""

def _stringify_value(value):
    return "\"%s\"" % value if type(value) in ["string", "Label"] else value

def _stringify_item(value_type, item):
    if value_type == "list":
        return [_stringify_value(i) for i in item]
    return _stringify_value(item)

def _stringify_dict_items(d):
    return {
        _stringify_value(k): _stringify_item(type(v), v) for k, v in d.items()
    }

def stringify(value):
    """Wraps strings and Labels in double quotes for use in `BUILD` files."""
    value_type = type(value)

    if value_type == "dict":
        return _stringify_dict_items(value)
    return _stringify_item(value_type, value)

def stringify_args(args, indent = " " * 4):
    """Formats a dict as `BUILD` rule or macro arguments."""
    return "".join([
        "%s%s = %s,\n" % (indent, k, stringify(v))
        for k, v in args.items()
    ])

