#!/bin/bash
# Double-click this file to launch a live preview of the AEM 7010 site in your browser.
# Quarto must be installed (https://quarto.org/docs/get-started/).

cd "$(dirname "$0")"
echo "Starting Quarto preview from $(pwd)"
echo "Press Ctrl+C in this window to stop the server."
echo ""
quarto preview
