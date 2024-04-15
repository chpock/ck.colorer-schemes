

wc -c <(echo abc && echo def)
wc -c <(echo abc; echo def)
echo abc > >(wc -c)
