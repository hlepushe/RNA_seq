import sys

def process_fastq(input_file, output_file):
    with open(input_file, "r") as infile, open(output_file, "w") as outfile:
        lines = infile.readlines()
        umi_length = 0  # Will be calculated from first record
        
        for i, line in enumerate(lines):
            r_n = (i % 4) + 1  # Line type within a record
            if r_n == 1:  # Header line
                # Extract UMI length from header for dynamic removal
                first_part = line.split(" ")[0]
                if "_" in first_part:
                    umi = first_part.split("_")[-1].strip()
                    umi_length = len(umi) * 3  # 3 repetitions
                outfile.write(line)
            elif r_n == 2:  # Sequence line
                modified_sequence = line[umi_length:]
                outfile.write(modified_sequence)
            elif r_n == 3:  # "+" line (delimiter)
                outfile.write(line)
            elif r_n == 4:  # Quality line
                modified_quality = line[umi_length:]
                outfile.write(modified_quality)

if __name__ == "__main__":
    input_fastq = sys.argv[1]
    output_fastq = sys.argv[2]
    process_fastq(input_fastq, output_fastq)
