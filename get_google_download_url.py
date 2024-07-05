## Name: get_google_download_url.py
## Author: Jackie Chen
## Description: Parse a google drive shared link into a new url that is directly downloadable.

#!/usr/bin/python3 
import sys

# Main function
def main():
    shared_link = str(sys.argv[1])  # i.e. https://drive.google.com/file/d/1FNVU-equEtf4uzuVYbexAeUwksPWHZ2s/view?usp=sharing
    parsed_list = list(shared_link.split('/'))
    # print(parsed_list)

    search_index = 0
    search_found = 0
    for item in parsed_list:
        if item == 'd':
            search_found = 1
            break
        search_index += 1

    if search_found == 1:
        search_index += 1  # locate the donwload_id
    
    # print(parsed_list[search_index])
    download_url = str(f"https://drive.google.com/uc?export=download&id={parsed_list[search_index]}")
    print(download_url)

if __name__ == "__main__":
    main()
