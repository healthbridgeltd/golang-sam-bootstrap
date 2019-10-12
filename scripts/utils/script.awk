{
    sub(/\./, ",", $NF)
    str = str","$NF
}
END { print str}
