# cmd options parser is taken from https://stackoverflow.com/a/14203146

SOURCE_DIR=.
MODE="train"
DATAROOT='full_dataset'
MAX_LEN=300

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -s|--source-dir)
    SOURCE_DIR="$2"
    shift # past argument
    shift # past value
    ;;
    -d|--dataroot)
    DATAROOT="$2"
    shift # past argument
    shift # past value
    ;;
    -m|--mode)
    MODE="$2"
    shift # past argument
    shift # past value
    ;;
    --max-len)
    MAX_LEN="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}"

bash data/extract_imgs.sh -s $SOURCE_DIR -t ffmpeg_tmp -o $DATAROOT/${MODE}_img --max-len $MAX_LEN
python data/face_landmark_detection.py $MODE $DATAROOT
bash data/rm_bad_keypoints.sh $DATAROOT $MODE
