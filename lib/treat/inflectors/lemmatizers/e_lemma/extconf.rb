require 'mkmf'

$CFLAGS = "-Wall -I/usr/local/WordNet-2.1/include/"
$LOCAL_LIBS = "-L/usr/local/WordNet-2.1/lib -lwn"

create_makefile("elemma")