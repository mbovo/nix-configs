# Copyright (C) 2023 Luigi Operoso
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#!/usr/bin/env python
import os
import re
import argparse
import logging
from typing import Any, Dict

logging.basicConfig(level=logging.ERROR)

def parse_nix_module(file_path: str) -> dict:
    options:Dict[Any, Any] = {}
    if not os.path.exists(file_path):
        logging.error(f"File not found: {file_path}")
        return options

    with open(file_path, 'r') as file:
        content = file.read()

    # Thanks openai for the regex patterns
    option_pattern = re.compile(r'([a-zA-Z0-9_.-]+)\s*=\s*lib\.mkOption\s*{([^}]*)}', re.DOTALL)
    desc_pattern = re.compile(r'description\s*=\s*\'\'\n\s*(.*?)\s*\'\'', re.DOTALL)
    type_pattern = re.compile(r'type\s*=\s*lib\.types\.([a-zA-Z0-9_.-]+)')
    default_pattern = re.compile(r'default\s*=\s*(.*?);', re.DOTALL)

    for match in option_pattern.finditer(content):
        option_name = match.group(1).strip()
        option_body = match.group(2).strip()

        description = desc_pattern.search(option_body)
        option_type = type_pattern.search(option_body)
        default = default_pattern.search(option_body)

        options[option_name] = {
            'description': description.group(1).strip() if description else '',
            'type': option_type.group(1).strip() if option_type else '',
            'default': default.group(1).strip() if default else '',
        }

    return options

def generate_readme(module_name: str, options: dict) -> str:
    readme_content = f"# {module_name} Module Options\n\n"
    readme_content += "| Option | Description | Type | Default |\n"
    readme_content += "|--------|-------------|------|---------|\n"

    for option, details in options.items():
        readme_content += f"| `{option}` | {details['description']} | {details['type']} | {details['default']} |\n"

    return readme_content

def process_nix_files_in_directory(directory: str, write: bool):
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.nix'):
                file_path = os.path.join(root, file)
                module_name = os.path.basename(file_path).replace('.nix', '')

                logging.info(f"Parsing file: {file_path}")
                options = parse_nix_module(file_path)
                if options:
                    readme = generate_readme(module_name, options)
                    readme_filename = os.path.join(root, 'README.md') if write else None

                    if write and readme_filename:
                        with open(readme_filename, 'w') as readme_file:
                            readme_file.write(readme)
                        logging.info(f"README.md has been generated at {readme_filename}.")
                    else:
                        print(readme)
                else:
                    logging.warning(f"No options found in file: {file_path}")


def main():
    parser = argparse.ArgumentParser(description="Recursively parse Nix module files and generate README files.")
    parser.add_argument('directory_path', type=str, help="Path to the directory containing Nix module files")
    parser.add_argument('-w', '--write', action='store_true', help="Write the output to README.md files instead of printing")
    args = parser.parse_args()

    directory_path = args.directory_path
    if not os.path.isdir(directory_path):
        logging.error(f"Directory not found: {directory_path}")
        return

    process_nix_files_in_directory(directory_path, args.write)

if __name__ == "__main__":
    main()