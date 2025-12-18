import sys

def process_fastq(input_file, output_file):
    UMI = ""
    q = "I" * 10  # Quality string to repeat
    with open(input_file, "r") as infile, open(output_file, "w") as outfile:
        lines = infile.readlines()
        for i, line in enumerate(lines):
            r_n = (i % 4) + 1  # Line type within a record
            if r_n == 1:  # Header line
                first_part = line.split(" ")[0]  # Get part before space
                # Extract UMI after the last underscore
                if "_" in first_part:
                    UMI = first_part.split("_")[-1]  # Get everything after last underscore
                else:
                    UMI = ""  # Fallback if no underscore found
                outfile.write(line)
            elif r_n == 2:  # Sequence line
                modified_sequence = f"{UMI}{UMI}{UMI}{line.strip()}\n"
                outfile.write(modified_sequence)
            elif r_n == 3:  # "+" line (delimiter)
                outfile.write(line)
            elif r_n == 4:  # Quality line
                # Adjust quality string length to match UMI length
                umi_quality = "I" * len(UMI)
                modified_quality = f"{umi_quality}{umi_quality}{umi_quality}{line.strip()}\n"
                outfile.write(modified_quality)

if __name__ == "__main__":
    input_fastq = sys.argv[1]
    output_fastq = sys.argv[2]
    process_fastq(input_fastq, output_fastq)
