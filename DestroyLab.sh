#!/bin/bash

# Variables
resourceGroupName="SOCAnalystTrainingLab"

# Confirm before deletion
echo "Are you sure you want to delete all resources in $resourceGroupName? (y/n)"
read confirmation
if [ "$confirmation" = "y" ]; then
    az group delete --name $resourceGroupName --yes --no-wait
    echo "Resources are being deleted..."
else
    echo "Deletion cancelled."
fi
