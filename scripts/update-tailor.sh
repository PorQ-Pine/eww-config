#!/bin/bash
tailor_cli profile list | awk '/\(active\)/ {print $1}'
