

cat <<EOF > $tmpfile
a $B ${C}
EOF

wc -l $tmpfile
