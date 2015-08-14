echo "Start deploy";
rcNum=0;
rcMasterNumber=0;
rcSlaveNumber=0;
rcMasterNumber=$(kubectl get rc | grep "hellomaster" | tail -c 3);
rcSlaveNumber=$(kubectl get rc | grep "helloslave" | tail -c 3);
if((($rcMasterNumber)&&($rcSlaveNumber))); then
	echo "MasterRC=$rcMasterNumber or SlaveRC=$rcSlaveNumber not clean";
  exit -1;
elif((($rcMasterNumber))); then
  echo "Transfer RC from Master to Slave";
	while (($rcMasterNumber));do
	((rcNum++));
	((rcMasterNumber--));
	kubectl scale --replicas=$rcNum replicationcontrollers helloslave;
	kubectl scale --replicas=$rcMasterNumber replicationcontrollers hellomaster;
	kubectl get rc;
	done;
elif((($rcSlaveNumber))); then
  echo "Transfer RC from Slave to Master";
	while (($rcSlaveNumber));do
	((rcNum++));
	((rcSlaveNumber--));
	kubectl scale --replicas=$rcSlaveNumber replicationcontrollers helloslave;
	kubectl scale --replicas=$rcNum replicationcontrollers hellomaster;
	kubectl get rc;
	done;
fi;
echo "End deploy";