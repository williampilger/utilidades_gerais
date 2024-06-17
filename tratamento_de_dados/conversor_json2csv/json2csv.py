import json
import csv
import sys

def json_to_csv(input_file, output_file='output.csv'):
    def flatten_json(y):
        out = {}

        def flatten(x, name=''):
            if type(x) is dict:
                for a in x:
                    flatten(x[a], name + a + '.')
            elif type(x) is list:
                i = 0
                for a in x:
                    flatten(a, name + str(i) + '.')
                    i += 1
            else:
                out[name[:-1]] = x

        flatten(y)
        return out

    with open(input_file, 'r') as f:
        json_array = json.load(f)

    with open(output_file, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile, quoting=csv.QUOTE_MINIMAL)
        headers_written = False

        for entry in json_array:
            flat_entry = flatten_json(entry)
            if not headers_written:
                headers = flat_entry.keys()
                writer.writerow(headers)
                headers_written = True
            writer.writerow(flat_entry.values())

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Por favor, informe o nome do arquivo de entrada.")
    else:
        input_file = sys.argv[1]
        output_file = sys.argv[2] if len(sys.argv) > 2 else 'output.csv'
        json_to_csv(input_file, output_file)
