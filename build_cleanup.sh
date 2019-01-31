#!/usr/bin/env bash

echo ""
echo "   CLEAN & MINIFY"
echo " ---------------------   ---  -- -"

BUILDCMD='rm -R build/assets/stylesheets/bulma; rm -R build/source; rm -R build/pagemd; rm build/.editorconfig'
eval "$BUILDCMD"

echo ""
echo "  CLEAN FINISHED. STARTING PURGECSS"
echo ""

BUILDCMD='/Users/eve/.nvm/versions/node/v9.4.0/bin/node ./purgecss.js'
eval "$BUILDCMD"

echo ""
echo "Clean Up Completed!"
echo ""
