#!/bin/bash

echo "======================================"
echo "PADRO-AI-LABS WSL HEALTH CHECK"
echo "======================================"
echo ""

echo "DATE:"
date
echo ""

echo "HOST:"
hostname
echo ""

echo "UPTIME:"
uptime
echo ""

echo "CPU THREADS:"
nproc
echo ""

echo "MEMORY:"
free -h
echo ""

echo "TOP MEMORY CONSUMERS:"
ps aux --sort=-%mem | head -10
echo ""

echo "DISK:"
df -h
echo ""

echo "KERNEL:"
uname -a
echo ""

echo "DONE."
