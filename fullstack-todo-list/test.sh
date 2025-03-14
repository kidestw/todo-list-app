#!/bin/bash

# Function to check if a service is running
check_service() {
    local service_name=$1
    local service_url=$2

    echo "Checking $service_name at $service_url..."
    
    if curl --fail --silent --head "$service_url"; then
        echo " $service_name is UP!"
    else
        echo "$service_name is DOWN!"
    fi
    echo "------------------------------------"
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo " Docker is not running. start Docker and try again."
    exit 1
fi

echo "Running container health checks..."

# 1️⃣ Check if backend container is running
if docker ps | grep -q "backend"; then
    echo " Backend container is running."
else
    echo " Backend container is NOT running."
fi

# 2️⃣ Check if MongoDB container is running
if docker ps | grep -q "mongo"; then
    echo " MongoDB container is running."
else
    echo " MongoDB container is NOT running."
fi

# 2️⃣ Check if Frontend container is running
if docker ps | grep -q "frontend"; then
    echo "Frontend container is running."
else
    echo "Frontend container is NOT running."
fi

# 3️⃣ Test Backend API (Replace with your actual API endpoint)
check_service "Backend API" "http://localhost:5000/api/todos"

# 4️⃣ Test MongoDB Connection (Inside container)
echo "Checking MongoDB connection..."
docker exec -it $(docker ps -qf "name=mongo") mongosh --eval "db.runCommand({ping: 1})"

# 5️⃣ If frontend exists, test it
if docker ps | grep -q "frontend"; then
    check_service "Frontend App" "http://localhost:5137"
fi

echo "All checks complete!"
