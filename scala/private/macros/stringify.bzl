"""Utilities for converting values for use in BUILD files"""

def stringify_list_value(value):
    return "%s" % value if type(value) in ["string", "Label"] else value

def stringify(value):
    """Wraps string values in double quotes for use in `BUILD` files."""
    if type(value) == "list":
        return [stringify_list_value(i) for i in value]
    return "\"%s\"" % value if type(value) in ["string", "Label"] else value

def stringify_args(args, indent = " " * 4):
    """Formats a dict as `BUILD` rule or macro arguments."""
    return "".join([
        "%s%s = %s,\n" % (indent, k, stringify(v))
        for k, v in args.items()
    ])

