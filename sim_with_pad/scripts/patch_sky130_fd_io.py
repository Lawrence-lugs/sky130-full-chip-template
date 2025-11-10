#!/usr/bin/env python3
import sys
import os
import re

if len(sys.argv) != 3:
    print("Usage: patch_sky130_fd_io.py <input.v> <output.v>")
    sys.exit(1)

input_file = sys.argv[1]
output_file = sys.argv[2]

os.makedirs(os.path.dirname(output_file), exist_ok=True)

with open(input_file, "r") as f:
    lines = f.readlines()

output_lines = []
inside_module = False
module_lines = []
assign_lines = []

for line in lines:
    # Check if a module starts
    if re.match(r'^\s*module\s+\w+', line):
        inside_module = True
        module_lines = [line]
        assign_lines = []
        continue

    # Check if we are inside a module
    if inside_module:
        module_lines.append(line)

        # Check if line is a declaration to move
        if re.match(r'^\s*(assign)', line):
            assign_lines.append(line)
            module_lines[-1] = ""  # Remove from original position

        # Check if module ends
        if re.match(r'^\s*endmodule', line):
            inside_module = False
            # Write module: module line + rest of module + patched lines before endmodule
            # Insert assign_lines just before endmodule
            for ml in module_lines[:-1]:
                if ml:  # skip empty lines
                    output_lines.append(ml)
            for al in assign_lines:
                output_lines.append(al)
            output_lines.append(module_lines[-1])  # endmodule
            module_lines = []
            assign_lines = []
    else:
        output_lines.append(line)

with open(output_file, "w") as f:
    f.writelines(output_lines)

print(f"Patched {input_file} -> {output_file}")
