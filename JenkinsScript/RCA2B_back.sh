echo "Start deploy"
moveTag=1  #1 A2B; 0 B2A
moveTag=$1 #1 A2B; 0 B2A
echo $moveTag
rcGroupANumber=$(kubectl get rc | grep "hellogroupa" | tail -c 3)
rcGroupBNumber=$(kubectl get rc | grep "hellogroupb" | tail -c 3)
if [[ 1 -eq $moveTag ]] 
then
  echo "RC move from A2B, move $rcGroupANumber times"
  while (($rcGroupANumber))
  do
  	((rcGroupANumber--))
	((rcGroupBNumber++))
	kubectl scale --replicas=$rcGroupANumber replicationcontrollers hellogroupa
	kubectl scale --replicas=$rcGroupBNumber replicationcontrollers hellogroupb
	kubectl get rc
  done
elif [[ 0 -eq $moveTag ]]
 then
  echo "RC move from B2A, move $rcGroupBNumber times"
  while (($rcGroupBNumber))
  do
	((rcGroupANumber++))
	((rcGroupBNumber--))
	kubectl scale --replicas=$rcGroupANumber replicationcontrollers hellogroupa
	kubectl scale --replicas=$rcGroupBNumber replicationcontrollers hellogroupb
	kubectl get rc
  done
fi
echo "End deploy"
