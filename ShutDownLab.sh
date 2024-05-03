#!/bin/bash

# Variables
resourceGroupName="SOCAnalystTrainingLab"

# Stop all VMs in the resource group
az vm deallocate --resource-group $resourceGroupName --ids $(az vm list --resource-group $resourceGroupName --query "[].id" -o tsv)
