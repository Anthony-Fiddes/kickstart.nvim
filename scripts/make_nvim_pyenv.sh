#!/bin/sh
pyenv install 3.10 --skip-existing
pyenv virtualenv 3.10 neovim

# Exit if an error occurs
set -e

python_host=$(pyenv root)/versions/neovim/bin/python
globals_file="../lua/custom/generated_globals.lua"
python3_var="vim.g.python3_host_prog"
new_assignment="$python3_var = \"$python_host\""

$python_host -m pip install pynvim
touch $globals_file
echo $(pyenv which python)
if ! grep -q $python3_var $globals_file; then
	echo >> $globals_file
	echo $new_assignment >> $globals_file
else
	sed -i "/$python3_var/c\\$new_assignment" $globals_file
fi
