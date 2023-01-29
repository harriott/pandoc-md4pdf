#!/bin/bash
# vim: set sw=2:

# Joseph Harriott - Fri 13 Jan 2023

# line that breaks $VIMRUNTIME/syntax/sh.vim
# ------------------------------------------
# so kept separate here, sourced by $MD4PDF/GNULinux/md4pdf.sh

# https://github.com/vim/vim/issues/11809 (my $IT1/CP/Vim/substitute_hash_into_string.gfm)

cmdpn1=${cmdpn0//#/\\#} # (escaping any hashes in filename for passing to TeX)

