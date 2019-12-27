#!/bin/bash
dt=`date +"%F_%k:%M"` #videofil format: y-m-d_h:m

cd ~/pi-pic/
raspivid -o origVid.h264 -fps 15 -t 10000 #optag 10 sek
MP4Box -add origVid.h264 -fps 15 temp.mp4 #encode

ffmpeg -ss 5 -i temp.mp4 -c copy -t 1 trimVid.mp4 #trim fra 5 sek og 1 sek frem

if [ ! -d "$1-videos" ]; then #opret directory
	mkdir $1-videos
fi
cp trimVid.mp4 $1-videos/$dt.mp4 #kopier video med 'dt' navnformat til mappen


file="$1.mp4" 


if [ -f "$file" ] #hvis filen eksisterer
then # konkatener filerne
	printf "file '$file'\nfile 'trimVid.mp4'" > .listOfFiles.txt 
	ffmpeg -f concat -i .listOfFiles.txt -c copy joinedVideo.mp4
	mv joinedVideo.mp4 $file
	rm trimVid.mp4
else #ellers omdøbes filen blot
	mv trimVid.mp4 $file
fi


# fjern temp filer
rm temp.mp4 
rm origVid.h264


#######
# stillphoto
#######

#opret dir
if [ ! -d "$1-photos" ]; then
	mkdir $1-photos
fi


# take photo "-hf" og "-vf" for flip
raspistill -o $1-photos/$dt.jpg


