#!/usr/bin/env bash
set +e

MIDDLECMD=''
A=false
B=false
C=false
D=false

function helpMsg {
    printf "

  ----- Mumford Middleman -----
  --                         --
  --    -l : Live Reload     --
  --    -b : Build Website   --
  --    -w : Webpack         --
  --    -s : S3 Sync         --
  --                         --
  -----------------------------

    "
}

# Parse Parameters #
for ARG in "$@"; do
    case $ARG in
        -l|--live)
            A=true
            ;;
        -b|--build)
            B=true
            ;;
        -w|--webpack)
            C=true
            ;;
        -s|--s3sync)
            D=true
            ;;
        *)
            echo "  OPTION NOT FOUND. TRY AGAIN? "
            ;;
    esac
done

if [ "$A" = true ]; then
    MIDDLECMD='NO_CONTRACTS=true bundle exec middleman server'
    MIDMSG='MIDDLEMAN LIVE RELOAD'
fi

if [ "$B" = true ]; then
    MIDDLECMD='bundle exec middleman build'
    # MIDDLECMD='bundle exec middleman build; node purgecss.js'
    MIDMSG='MIDDLEMAN BUILD'
fi

if [ "$C" = true ]; then
    MIDDLECMD='BUILD_DEVELOPMENT=1 ./node_modules/webpack/bin/webpack.js --watch -d --progress --color'
    MIDMSG='NODE.JS WEBPACK'
fi

if [ "$D" = true ]; then
    MIDDLECMD='middleman s3_sync'
    MIDMSG='BUILD & DEPLOY'
fi

if [ "$A" = false ] && [ "$B" = false ] && [ "$C" = false ] && [ "$D" = false ]; then
    MIDDLECMD=''
    echo ""
    echo "  NO OPTION PROVIDED!"
    helpMsg
else
    echo ""
    echo " RUN $MIDMSG";
    echo "- -  --   ---------------   --  - -"
    echo ""
fi

eval "$MIDDLECMD"

if [ "$B" = true ] || [ "$D" = true ]; then
    BUILDCMD='rm -R build/assets/stylesheets/bulma; rm -R build/source; rm -R build/pagemd; rm build/.editorconfig'
    eval "$BUILDCMD"
    echo ""
    echo "Clean Up Completed!"
    echo ""
fi
