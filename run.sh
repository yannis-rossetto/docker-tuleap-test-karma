#!/bin/bash

install_environment(){
    npm install
    bower install --allow-root --config.interactive=false
}

BASE_PATH="/tuleap";
TEST_REPORT="test-results.xml";

set -e

options=`getopt -o h -l path:,output-dir: -- "$@"`

eval set -- "$options"

while true
do
    case "$1" in
	--path)
	    path=$2;
	    shift 2;;
    --output-dir)
        output_dir=$2;
        shift 2;;
	--)
	    shift 1; break ;;
	*)
	    break ;;
    esac
done

if [ -n "$path" ]; then
    cd $BASE_PATH/$path
    install_environment
    grunt
else
    echo "You must specify --path argument"
    exit 1;
fi

# Build rpm
plugin_base=$BASE_PATH/$path/../../..
if [ -f $plugin_base/Makefile -a -f $plugin_base/tuleap-plugin-testing-backend.spec ]; then
    make -C $BASE_PATH less
    make -C $plugin_base RPM_TMP=$output_dir/packages
fi

if [ -n "$output_dir" ]; then
    mkdir -p $output_dir
    mv $BASE_PATH/$path/$TEST_REPORT $output_dir/
fi
