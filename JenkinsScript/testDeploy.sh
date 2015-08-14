echo "Start test"
rcTag=0  #1 A2B; 2 B2A
rcNum=0  #move number
rcFinishNum=0
rcTotalNum=0 #move total number
echo "Default rcTag=$rcTag, rcNum=$rcNum, rcFinishNum=$rcFinishNum, rcTotalNum=$rcTotalNum"

tmpFile="/tmp/jenkins/RCDeploy.txt"
if [ -f "$tmpFile" ]
then 
	source $tmpFile 
	echo "Got from $tmpFile, rcTag=$rcTag , rcNum=$rcNum ,rcFinishNum=$rcFinishNum, rcTotalNum=$rcTotalNum"
fi

moveNum=0;
let leftNum=rcTotalNum-rcFinishNum
if((($leftNum) > ($rcNum)))
then
	let moveNum=rcNum
else
	let moveNum=leftNum
	
fi

echo "leftNum=$leftNum, move $moveNum times"
let rcFinishNum=rcFinishNum+moveNum
echo "rcFinishNum=$rcFinishNum"
if((($rcTotalNum) > ($rcFinishNum)))
then
  
  sh /tmp/JenkinsScript/Deploy_tmp.sh $rcTag $rcNum $rcFinishNum $rcTotalNum 

else
  echo "Remove the file $tmpFile"
  rm $tmpFile
fi
echo "End test"
