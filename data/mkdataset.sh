# cmd options parser is taken from https://stackoverflow.com/a/14203146

SOURCE_DIR=.
TMP_DIR=.
OUT_DIR='full_dataset'
KEEP_TEMPS=0
FPS=15
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
    -t|--tmp-dir)
    TMP_DIR="$2"
    shift # past argument
    shift # past value
    ;;
    -o|--output-dir)
    OUT_DIR="$2"
    shift # past argument
    shift # past value
    ;;
    --fps)
    FPS="$2"
    shift # past argument
    shift # past value
    ;;
    --max-len)
    MAX_LEN="$2"
    shift # past argument
    shift # past value
    ;;
    --keep-temps)
    KEEP_TEMPS=1
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}"

mkdir -p $TMP_DIR

for video in `ls -v $SOURCE_DIR/*.MOV`;
do
    video_name="${video%.*}"
    ffmpeg_dir=$TMP_DIR/$video_name

    echo "Creating ffmpeg output directory for $video if not exists"
    mkdir -p $ffmpeg_dir

    if ! [ -f "$ffmpeg_dir/00001.jpg" ]
    then
        echo "Run ffmpeg for $video"
        ffmpeg -v warning -ss 0 -i $video -to $MAX_LEN -filter:v fps=$FPS $ffmpeg_dir/%05d.jpg
    fi
done;

output_prefix=$OUT_DIR

mkdir -p $output_prefix

total_files=0
for video_dir in `ls -d $TMP_DIR/person*/`;
do
    total_files=$(expr $total_files + $(ls $video_dir | wc -l))
done;
echo "Total images: $total_files"

if [[ $total_files -eq 0 ]]
then
    exit
fi

processed_files=0
processed_perc=0
dir_shift=0

echo "Transforming to vid2vid format"
for video_dir in `ls -d $TMP_DIR/person*/`;
do
    dir_files=$(ls $video_dir | wc -l)
    max_dir=0
    for file in `ls -v $video_dir`;
    do
        ((processed_files++))

        filenum=$(expr $(echo $file | sed -e s/[^0-9]//g) - 1)

        if [ $(expr $dir_files - $filenum) -lt 28 ] && [ $(expr $filenum % 28) -eq 0 ]
        then
            break
        fi

        filename=$(printf "%05d" $(expr $filenum % 28 + 1))
        dir=$(printf "%05d" $(expr $filenum / 28 + $dir_shift + 1))

        max_dir=$dir

        output_dir=$output_prefix/$dir

        if ! [ -d $output_dir ]
        then
            mkdir $output_dir
        fi

        cp $video_dir/$file $output_dir/$filename.jpg

        if ! [ $(expr $filenum \* 100 / $total_files - $processed_perc) -eq 0 ]
        then
            processed_perc=$(expr $processed_files \* 100 / $total_files)
            echo -ne "\rprocessing... ${processed_perc}%"
        fi
    done;
    dir_shift=$max_dir
    
    if [[ $KEEP_TEMPS -eq 0 ]]
    then
        rm -r $video_dir
    fi
done;
# echo -ne "\r"
echo

CUR_DIR=.

if [[ "$TMP_DIR" == "$CUR_DIR" ]] || [ $KEEP_TEMPS -eq 0 ]
then
    rm -r $TMP_DIR
fi
