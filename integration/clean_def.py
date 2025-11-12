import sys

skip_start = ['ROW','TRACKS']
skip_between = [('COMPONENTS','END COMPONENTS'), ('SPECIALNETS','END SPECIALNETS'), ('NETS','END NETS')]

def turn_numbers_to_zero(line):
    parts = line.split()
    new_parts = []
    for part in parts:
        try:
            float(part)
            new_parts.append('0')
        except ValueError:
            new_parts.append(part)
    return ' '.join(new_parts) + '\n'

if __name__ == "__main__":
    # get input file and output file from command line arguments
    input_file = sys.argv[1]
    output_file = sys.argv[2]

    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        skiprange = False
        skipthis = False
        for line in infile:

            if skiprange:
                skipthis = True

            # skip lines between specified pairs
            for start, end in skip_between:
                if skiprange:
                    if line.startswith(end):
                        skiprange = False
                        skipthis = False
                        break
                if line.startswith(start):
                    skiprange = True
                    line = turn_numbers_to_zero(line)

            # skiprange lines that start with 
            if any(line.startswith(skipline) for skipline in skip_start):
                skipthis = True

            if skipthis:
                skipthis = False
                continue
            else:
                outfile.write(line)