import sys
import glob
import argparse

def merge_files(file_pattern, output_file):
    file_paths = glob.glob(file_pattern)
    with open(output_file, 'a', encoding='utf-8') as outfile:
        for file_path in file_paths:
            with open(file_path, 'r', encoding='utf-8') as infile:
                outfile.write(infile.read() + '\n\n')
    print(f'Files merged into {output_file}')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Merge SQL files.')
    parser.add_argument('files', type=str, help='Pattern for files to merge, e.g., *.sql')
    parser.add_argument('-o', '--output', type=str, default='merged_output', help='Output file name.')

    args = parser.parse_args()

    merge_files(args.files, args.output)
