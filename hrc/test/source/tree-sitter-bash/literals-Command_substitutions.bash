

echo `echo hi`
echo `echo hi; echo there`
echo $(echo $(echo hi))
echo $(< some-file)

# both of these are concatenations!
echo `echo otherword`word
echo word`echo otherword`
