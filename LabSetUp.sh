# Variables
resourceGroupName="SOCAnalystTrainingLab"
location="EastUS"
vnetName="SOCLabVNet"
subnetName="SOCLabSubnet"
nsgName="SOCLabNSG"
vmSize="Standard_DS1_v2"
ubuntuImage="Canonical:UbuntuServer:19_04-daily-gen2:19.04.202001230"

# Read credentials from file
readarray -t credentials < credentials.txt
adminUsername="${credentials[0]}"
adminPassword="${credentials[1]}"

# Create a Resource Group
az group create --name $resourceGroupName --location $location

# Create Virtual Network and Subnet
az network vnet create --resource-group $resourceGroupName --name $vnetName --address-prefix "10.0.0.0/16" --subnet-name $subnetName --subnet-prefix "10.0.0.0/24"

# Create Network Security Group and rule
az network nsg create --resource-group $resourceGroupName --name $nsgName
az network nsg rule create --resource-group $resourceGroupName --nsg-name $nsgName --name "AllowSSH" --protocol Tcp --priority 1000 --destination-port-range 22 --access Allow --direction Inbound --source-address-prefix "Internet"

# Create Network Interfaces for the VMs
az network nic create --resource-group $resourceGroupName --name "FileServerNIC" --vnet-name $vnetName --subnet $subnetName --network-security-group $nsgName
az network nic create --resource-group $resourceGroupName --name "EmployeeNIC" --vnet-name $vnetName --subnet $subnetName --network-security-group $nsgName
az network nic create --resource-group $resourceGroupName --name "SIEMNIC" --vnet-name $vnetName --subnet $subnetName --network-security-group $nsgName

# Create Employee VM with proper images
az vm create --resource-group $resourceGroupName --name "EmployeeVM" --image "Win2022Datacenter" --size $vmSize --admin-username $adminUsername --admin-password $adminPassword --nics "EmployeeNIC"

# Deploy VMs with proper images
# Create File Server VM
az vm create \
  --resource-group $resourceGroupName \
  --name FileServerVM \
  --nics FileServerNIC \
  --image $ubuntuImage \
  --size $vmSize \
  --admin-username $adminUsername \
  --admin-password $adminPassword \
  --no-wait

# Create SIEM/SOAR VM
az vm create \
  --resource-group $resourceGroupName \
  --name SIEMServer \
  --nics SIEMNIC \
  --image $ubuntuImage \
  --size $vmSize \
  --admin-username $adminUsername \
  --admin-password $adminPassword \
  --no-wait

 