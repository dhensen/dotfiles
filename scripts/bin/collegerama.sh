#!/bin/bash

# resource ID of the video, can be obtained from the video URL:
#    https://collegerama.tudelft.nl/Mediasite/Play/485dbc9fac81446bae6b2ba2fe0571ac1d?catalog=cf028e9a-2a24-4e1f-bdb5-2ace3f9cd42d
#                                                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
id=$1
folder=$2

if [ -f $2 ]; then
    echo "folder $2 already exists, skipping"
    exit
fi

mkdir $2 && cd $2

SERVICE_ENDPOINT="https://collegerama.tudelft.nl/Mediasite/PlayerService/PlayerService.svc/json/GetPlayerOptions"

params="{\"getPlayerOptionsRequest\":{\"ResourceId\":\"${id}\",\"QueryString\":\"?catalog=cf028e9a-2a24-4e1f-bdb5-2ace3f9cd42d\",\"UseScreenReader\":false,\"UrlReferrer\":\"\"}}"
response=$(curl -s -X POST -H 'Content-Type: application/json' -d ${params} ${SERVICE_ENDPOINT})

title=$(echo "${response}" | jq '.d.Presentation.Title' -r)
airdate=$(echo "${response}" | jq '.d.Presentation.AirDate' -r)
presenters=$(echo "${response}" | jq '.d.Presentation.Presenters[].Name' -r)

echo "Thanks for the lecture, ${presenters}!\n"

video_urls=$(echo "${response}" | jq '.d.Presentation.Streams[].VideoUrls[].Location' -r)
for video_url in $video_urls
do
    wget -nc "${video_url}" -O "${title}_${airdate}.mp4"
done

slide_base_url=$(echo "${response}" | jq '.d.Presentation.Streams[0].SlideBaseUrl' -r)
slide_filename_format=$(echo "${response}" | jq '.d.Presentation.Streams[0].SlideImageFileNameTemplate' -r)

slide_timing_file=${title}_${airdate}_slide_timing
touch $slide_timing_file

slides=$(echo "${response}" | jq '.d.Presentation.Streams[].Slides[]' -r -c)
for slide in $slides
do
    time=$(echo "${slide}" | jq '.Time' -r)
    nr=$(echo "${slide}" | jq '.Number' -r)
    filename=$(echo $nr | xargs printf "slide_%.4d.jpg")

    echo -ne  "\rDownloading ${filename}"
    wget -q -nc "${slide_base_url}/${filename}" 

    echo "${nr},${time},${filename}" >> $slide_timing_file
done
#rm ${slide_timing_file}

echo "Done"
