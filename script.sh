#!/bin/bash

usage() 
{
  echo "Usage (Please use full paths):"
  echo "  ./script.sh <WEBRTC_SRC_PATH> <DEST_DIR_PATH> <COMPILE_GO_BINDINGS>"
  echo "WEBRTC_SRC_PATH = WebRTC source directory path"
  echo "DEST_DIR_PATH = Output directory path"
  echo "COMPILE_GO_BINDINGS = Set to compile Go bindinds"
  echo ""
  echo ""
}

usage

WEBRTC_SRC_PATH="$1"
DEST_DIR="$2"
COMPILE_GO_BINDINGS="$3"

# https://stackoverflow.com/a/31285400
STDDEF_PATH=`echo '#include<stddef.h>' | gcc -E - | grep stddef.h | head -n1 | sed 's/.*"\(.*\)".*/\1/' | sed 's/\/stddef.h//'`

if [ -z "$WEBRTC_SRC_PATH" ]; then
    echo "<WEBRTC_SRC_PATH> is empty. Aborting."
    exit 1
fi

if [ -z "$DEST_DIR" ]; then
    echo "<DEST_DIR_PATH> is empty. Aborting."
    exit 1
fi

if [ -z "$STDDEF_PATH" ]; then
    echo "File stddef.h not found! Aborting."
    exit 1
fi

command -v cmake >/dev/null 2>&1 || { echo >&2 "cmake is not installed. Aborting."; exit 1; }
command -v make >/dev/null 2>&1 || { echo >&2 "make is not installed. Aborting."; exit 1; }
command -v c-for-go >/dev/null 2>&1 || { echo >&2 "c-for-go is not installed. Aborting."; exit 1; }

echo "Using WEBRTC_SRC_PATH = $WEBRTC_SRC_PATH"
echo "Using DEST_DIR = $DEST_DIR"
echo "Using <stddef.h> location = $STDDEF_PATH"
echo ""
echo ""

echo "Creating $DEST_DIR/webrtc/common_audio"
mkdir -p "$DEST_DIR/webrtc/common_audio"

echo "Copying required files from WebRTC source"
cp -r "$WEBRTC_SRC_PATH/common_audio/vad" "$DEST_DIR/webrtc/common_audio"
cp -r "$WEBRTC_SRC_PATH/common_audio/signal_processing" "$DEST_DIR/webrtc/common_audio"
cp -r "$WEBRTC_SRC_PATH/rtc_base" "$DEST_DIR/webrtc"
cp -r "$WEBRTC_SRC_PATH/system_wrappers" "$DEST_DIR/webrtc"
cp -r "$WEBRTC_SRC_PATH/typedefs.h" "$DEST_DIR/webrtc"

echo "Copying CMakeLists.txt file"
cp -r "CMakeLists.txt" "$DEST_DIR/webrtc"

echo "Copying webrtc.yml"
cp -r "webrtc.yml" "$DEST_DIR"

echo "Making library..."
cd "$DEST_DIR/webrtc"
cmake -DINSTALL_DEST:STRING="$DEST_DIR" .
make
make install

echo "Making library done..."
echo ""

if [ -z "$COMPILE_GO_BINDINGS" ]; then
    echo "Not compiling Go bindings..."
else
    # https://stackoverflow.com/a/9366940
    sed -i "8s@_0_@\"$STDDEF_PATH\"@" "$DEST_DIR/webrtc.yml"
    sed -i "8s@_1_@\"$DEST_DIR/webrtc\"@" "$DEST_DIR/webrtc.yml"

    echo "Generating Go bindings..."
    cd "$DEST_DIR"
    c-for-go -out "$DEST_DIR/go" webrtc.yml

    cp "$WEBRTC_SRC_PATH/common_audio/vad/include/webrtc_vad.h" "$DEST_DIR/go/vad/"
    cp "$WEBRTC_SRC_PATH/typedefs.h" "$DEST_DIR/go/vad/"
fi

rm -rf "$DEST_DIR/webrtc"
rm -rf "$DEST_DIR/webrtc.yml"

echo ""
echo "Done! Please check \"$DEST_DIR\""
echo ""