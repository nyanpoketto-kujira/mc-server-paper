#!/bin/bash
echo "=== NYANPOKETTO MINECRAFT RUNNER ==="

# Download Portable JRE 21 kalau belum ada
if [ ! -d "jre" ]; then
  echo "[-] Downloading JRE 21..."
  curl -Lo jre.tar.gz "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.2%2B13/OpenJDK21U-jre_x64_linux_hotspot_21.0.2_13.tar.gz"
  mkdir jre
  tar -xzf jre.tar.gz -C jre --strip-components=1
  rm jre.tar.gz
fi

# Download PaperMC 1.20.4 kalau belum ada
if [ ! -f "paper.jar" ]; then
  echo "[-] Downloading PaperMC 1.20.4..."
  curl -Lo paper.jar "https://api.papermc.io/v2/projects/paper/versions/1.20.4/builds/496/downloads/paper-1.20.4-496.jar"
fi

# Auto Agree EULA
echo "eula=true" > eula.txt

# Sinkronisasi port Pterodactyl
if [ -n "$SERVER_PORT" ]; then
  echo "[-] Setting server port to $SERVER_PORT..."
  if [ -f "server.properties" ]; then
    sed -i "s/^server-port=.*/server-port=$SERVER_PORT/" server.properties
  else
    echo "server-port=$SERVER_PORT" >> server.properties
  fi
fi

# Set mode offline/cracked biar temen non-ori bisa login
if [ -f "server.properties" ]; then
  sed -i "s/^online-mode=.*/online-mode=false/" server.properties
else
  echo "online-mode=false" >> server.properties
fi

# Jalankan server (RAM 3.2 GB)
echo "=== STARTING PAPERMC ==="
./jre/bin/java -Xms1G -Xmx3200M -XX:+UseG1GC -jar paper.jar --nogui
