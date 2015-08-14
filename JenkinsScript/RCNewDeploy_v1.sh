echo "Start RCNewDeploy"
rcGroupANumber=0
rcGroupBNumber=0
rcGroupANumber=$(kubectl get rc | grep "hellogroupa" | tail -c 3)
rcGroupBNumber=$(kubectl get rc | grep "hellogroupb" | tail -c 3)
if ((($rcGroupANumber) && ($rcGroupBNumber)))
then
  echo "GroupARC=$rcGroupANumber or GroupBRC=$rcGroupBNumber not clean"
  exit -1
elif (($rcGroupANumber))
then
  echo "Transfer RC from GroupA to GroupB"
  rcNum=0
  moveNum=0;
  if(($rcGroupBNumber%2==0))
  then
  	let moveNum=rcGroupANumber/2
	echo "Transfer $moveNum times"
  	echo "RC is EVEN $rcGroupANumber, move $moveNum times"
  else
  	let moveNum=(rcGroupBNumber-1)/2
  echo $moveNum
  echo "RC is ODD $rcGroupANumber, move $moveNum times"
  fi
  while (($moveNum))
  do
	((rcNum++))
	((moveNum--))
	((rcGroupANumber--))
	kubectl scale --replicas=$rcNum replicationcontrollers hellogroupb
	kubectl scale --replicas=$rcGroupANumber replicationcontrollers hellogroupa
	kubectl get rc
  done
  sh /tmp/JenkinsScript/RCNewDeploy_tmp.sh 1
elif (($rcGroupBNumber))
then
  echo "Transfer RC from GroupB to GroupA"
  rcNum=0
  moveNum=0
  if(($rcGroupBNumber%2==0))
  then
  	let moveNum=rcGroupBNumber/2
  	echo "Transfer $moveNum times"
  	echo "RC is EVEN $rcGroupBNumber, move $moveNum times"
  else
  	let moveNum=(rcGroupBNumber-1)/2
  echo $moveNum
  echo "RC is ODD $rcGroupBNumber, move $moveNum times"
  fi
  while (($moveNum))
  do
	((rcNum++))
	((moveNum--))
	((rcGroupBNumber--))
	kubectl scale --replicas=$rcGroupBNumber replicationcontrollers hellogroupb
	kubectl scale --replicas=$rcNum replicationcontrollers hellogroupa
	kubectl get rc
  done
  sh /tmp/JenkinsScript/RCNewDeploy_tmp.sh 2
fi
echo "End RCNewDeploy"