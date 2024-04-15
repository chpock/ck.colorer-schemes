

cat <<OUTER
Outer Heredoc Start
$(cat <<INNER
Inner Heredoc Content
$(cat <<INNERMOST
Innermost Heredoc Content
INNERMOST
)
INNER)
Outer Heredoc End
OUTER
