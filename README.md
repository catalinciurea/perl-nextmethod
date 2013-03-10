# perl-nextmethod 

----
### This is a Vim plugin which offers mappins for [m, [M, ]m and ]M normal mode motions in perl files.

* ]m jumps to the next perl subroutine start
* ]M jumps to the next perl subroutine end
* [m jumps to the previous perl subroutine start
* [M jumps to the previous perl subroutine end

----
### Details

According to [ Vim documentation ]( http://vimdoc.sourceforge.net/htmldoc/motion.html#]m) these motion commands work only for '__Java  and similar structured languages__'

This plugin implements these motions in Perl scripts

### NOTES: 
* Standard Vim oprators: c, d and y are supported.
* Visual Selection operator v is not supported with these motions currently

[Catalin Ciurea](mailto:catalin@cpan.org)
