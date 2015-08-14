echo "Start RCA2B"
rcTag=0  #1 A2B; 2 B2A
#rcTag=$1 #1 A2B; 2 B2A
echo "Default rcTag=$rcTag, get from tmp_RCA2B.txt..."
source /tmp/jenkins/tmp_RCA2B.txt 
echo "Got the rcTag=$rcTag"
rcGroupANumber=$(kubectl get rc | grep "hellogroupa" | tail -c 3)
rcGroupBNumber=$(kubectl get rc | grep "hellogroupb" | tail -c 3)
if [[ 1 -eq $rcTag ]] 
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
elif [[ 2 -eq $rcTag ]]
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
echo "Remove the /tmp/jenkins/tmp_RCA2B.txt"
rm /tmp/jenkins/tmp_RCA2B.txt 
echo "End RCA2B"
