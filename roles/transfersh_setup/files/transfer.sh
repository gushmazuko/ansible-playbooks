#!/usr/bin/env bash
set -e

transfersh_url="https://free.keep.sh"
max_days=false
max_downloads=false
my_file=false
encrypt=false
file_name=false

help() {
	echo -e "Usage:\ntransfer <file_path> [-e] [-m <max_downloads>] [-d <max_days>]\n"
	echo "Options:"
	echo "  -e                      Encrypt the file using GPG"
	echo "  -m <max_downloads>      Limit the number of downloads"
	echo "  -d <days>               Set the number of days before deletion"
	exit 0
}

error() {
	echo -e "${1}"
	exit 1
}

encrypt_file() {
	file_name="${file_name}.gpg"
	gpg -ac -o "/tmp/${file_name}" "${my_file}"
	my_file="/tmp/${file_name}"
}

push() {
	if ${encrypt}; then
		encrypt_file
	fi

	curl_command=(curl --progress-bar --upload-file "${my_file}" "${transfersh_url}")

	if [[ ${max_days} != false ]]; then
		curl_command+=("-H" "Expires-After: ${max_days}")
	fi

	if [[ ${max_downloads} != false ]]; then
		curl_command+=("-H" "Max-Downloads: ${max_downloads}")
	fi

	response=$( "${curl_command[@]}" )

	if [[ ${response} == *"405 Not Allowed"* ]]; then
		error "Upload failed. Please check the server URL or your permissions."
	else
		url=$(echo "${response}" | tr -d '\r')

		if [[ -n $(command -v xclip) && -n ${DISPLAY} ]]; then
			echo "${url}" | tr -d '\n' | xclip -selection clipboard
			echo -e "URL copied to your clipboard:\n${url}"
		else
			echo "URL: ${url}"
		fi
	fi
}

check_file() {
	if [ -f "${1}" ]; then
		my_file="${1}"
		file_name=$(basename "${my_file}" | sed -e 's/[^a-zA-Z0-9._-]/-/g')
	else
		error "File not found. Please check the file path."
	fi
}

# Parsing command-line arguments
if [ ${#} -lt 1 ]; then
	help
fi

my_file=${1}
shift

while getopts "em:d:" opt; do
	case ${opt} in
		e)
			encrypt=true
			;;
		m)
			max_downloads=${OPTARG}
			;;
		d)
			max_days=${OPTARG}
			;;
		\?)
			help
			;;
	esac
done

check_file "${my_file}"
push
