dataset_dir=$1
mode=$2

total_removed=0

for keypoints in `ls -d ${dataset_dir}/${mode}_keypoints/*`;
do
    kp_count=$(ls $keypoints | wc -l)
    if [ $kp_count -lt 28 ]
    then
        sample_name=$(basename $keypoints)
	echo Removing sample $sample_name
        rm -r $keypoints
        rm -r ${dataset_dir}/${mode}_img/${sample_name}

	((++total_removed))
    fi
done;

echo Total removed samples count is $total_removed
