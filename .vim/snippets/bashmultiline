#passing multi-line text into a variable 
read -d '' variable << EOF
"$(cat ${HOME}/help/masterhelp.help)"
EOF
echo "$variable" | nl 
