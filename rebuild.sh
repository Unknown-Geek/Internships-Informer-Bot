#!/bin/bash

# Rebuild and restart Telegram Autoforward Docker container
# Run this script whenever you make changes to the Python script

echo "=========================================="
echo "Rebuilding Telegram Autoforward Container"
echo "=========================================="
echo ""

cd /home/ubuntu/Telegram-Autoforward-Script

# Step 1: Stop and remove existing container
echo "Step 1: Stopping existing container..."
if docker ps -a | grep -q telegram-autoforward; then
    docker stop telegram-autoforward 2>/dev/null
    docker rm telegram-autoforward 2>/dev/null
    echo "✓ Old container removed"
else
    echo "ℹ No existing container found"
fi
echo ""

# Step 2: Rebuild the Docker image
echo "Step 2: Rebuilding Docker image..."
docker build -t telegram-autoforward .

if [ $? -ne 0 ]; then
    echo "✗ Build failed!"
    exit 1
fi
echo "✓ Image rebuilt successfully"
echo ""

# Step 3: Start the new container
echo "Step 3: Starting new container..."
docker run -d \
    --name telegram-autoforward \
    --restart unless-stopped \
    -v "$(pwd):/app" \
    telegram-autoforward

if [ $? -ne 0 ]; then
    echo "✗ Failed to start container!"
    exit 1
fi
echo "✓ Container started"
echo ""

# Step 4: Verify
echo "Step 4: Verifying container status..."
sleep 2
if docker ps | grep -q telegram-autoforward; then
    echo "✓ Container is running"
    echo ""
    echo "=========================================="
    echo "✓ Rebuild complete!"
    echo "=========================================="
    echo ""
    echo "View logs with: docker logs -f telegram-autoforward"
else
    echo "✗ Container is not running!"
    echo "Check logs with: docker logs telegram-autoforward"
    exit 1
fi
