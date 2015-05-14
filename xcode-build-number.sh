#!/bin/bash

getValueFromInfoPlist() {
	echo `$PLISTBUDDY -c "Print $1" "${INFO_PLIST_PATH}"`
}

setValueForKeyInRootPlist () {
	# Search for the entries in the root.plist file
	for (( index=0; index<$ROOT_PLIST_COUNT; index++ )); do

		key=`"$PLISTBUDDY" -c "Print PreferenceSpecifiers:${index}:Key" "${ROOT_PLIST_PATH}"`

		if [ "$key" == "$1" ]; then
			echo "SETTING value $2 for key $key"

			`"$PLISTBUDDY" -c "Set PreferenceSpecifiers:${index}:DefaultValue $2" "${ROOT_PLIST_PATH}"`

			break
		fi
	done
}

# ============== STATIC Values ===============

INFO_PLIST_BUILD_KEY="CFBundleVersion"

INFO_PLIST_VERSION_KEY="CFBundleShortVersionString"

# ============================================

# ============== Default Values ==============
# Location of PlistBuddy
PLISTBUDDY="/usr/libexec/PlistBuddy"

# Common used Info.plist file
DEFAULT_INFO_PLIST_PATH="Info.plist"

# Common used settings root plist
DEFAULT_ROOT_PLIST_PATH="Root.plist"

# Commong used settings key for version number
DEFAULT_SETTINGS_BUILD_NUMBER="appBuildNumber"

# Commong used settings key for version number
DEFAULT_SETTINGS_VERSION_NUMBER="appVersionNumber"

# ============================================

declare -a readKeys
declare -a readKeysValues

declare -a writeKeys

# Validate if parameters provided
if [ $# -eq 0 ]; then
	echo "No arguments provided. Runnning with DEFAULT values."

	readKeys=("$INFO_PLIST_BUILD_KEY" "$INFO_PLIST_VERSION_KEY")
	writeKeys=("$DEFAULT_SETTINGS_BUILD_NUMBER" "$DEFAULT_SETTINGS_VERSION_NUMBER")
else

	# Validate provided the provided options
	while getopts ":b:v:" opt "$@"; do
	 	case $opt in
			b)
				echo "-b with argument '$OPTARG'" >&2

				readKeys+=($INFO_PLIST_BUILD_KEY)
				writeKeys+=($OPTARG)
				;;
			v)
				echo "-v with argument '$OPTARG'" >&2

				readKeys+=($INFO_PLIST_VERSION_KEY)
				writeKeys+=($OPTARG)
				;;
			p)
				echo "-p with argument '$OPTARG'" >&2
				;;
			:)
				echo "Option -$OPTARG requires argument." >&2
				exit 1
				;;
			\?)
				echo "Invalid option: -$OPTARG" >&2
				exit 1
				;;
	  esac
	done
fi

# # =============== Built Values ===============

# Application path
APP_PATH="${TARGET_BUILD_DIR}/${EXECUTABLE_NAME}.app"

# Info.plist path built with $APPPATH and INFOPLISTPATH
INFO_PLIST_PATH="${APP_PATH}/${DEFAULT_INFO_PLIST_PATH}"

echo "Using Info.plist path '${INFO_PLIST_PATH}'"

# Settings Root.plist built $APPPATH and INFOPLISTPATH
ROOT_PLIST_PATH="${APP_PATH}/Settings.bundle/${DEFAULT_ROOT_PLIST_PATH}"

echo "Using Root.plist path '${ROOT_PLIST_PATH}'"

settingsVersionKey="${DEFAULT_SETTINGS_VERSION_NUMBER}"

# ============================================

for key in "${readKeys[@]}"; do
	value=`getValueFromInfoPlist $key`

	echo "Adding value: $value for key: $key"

	readKeysValues+=($value)
done

# Retrieve the amount of dictionary entries in the root.plist file
ROOT_PLIST_COUNT=`"$PLISTBUDDY" -c "Print PreferenceSpecifiers:" "${ROOT_PLIST_PATH}" | grep "Dict" | wc -l`

# Validate if number of dictionary entries in the root.plist file is valid
if [ "$ROOT_PLIST_COUNT" -eq 0 ]; then
	echo "ERROR: Invalid count value: ${count}"
	exit 1
fi

for index in ${!writeKeys[@]}; do
	key=${writeKeys[$index]}
	value=${readKeysValues[$index]}

	echo "Index: $index Value: ${readKeysValues[$index]} for key: ${writeKeys[$index]}"

	setValueForKeyInRootPlist $key $value
done


