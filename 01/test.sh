#!/bin/bash
source $(dirname "$0")/functions.sh

$(dirname "$0")/clean.sh
mkdir $(dirname "$0")/test
$(dirname "$0")/main.sh "$(get_absolute_path test)" 10 bdgf 100 kl.pet 6kb