" Last Change : Mar 05 2013
" Author      : Catalin Ciurea <catalin@cpan.org>
" Source code : https://github.com/catalinciurea/perl-nextmethod
" Languages   : Perl 5
" License     : This plugin has the same license as Vim itself

if exists("g:perl_next_method_loaded") || &compatible || v:version < 700
    finish
endif
let g:perl_next_method_version = "0.0.2"

au FileType perl noremap <silent> ]m :call Perl_method_jump('')<CR>
au FileType perl noremap <silent> [m :call Perl_method_jump('b')<CR>
au FileType perl noremap <silent> ]M :call Perl_method_end_jump()<CR>
au FileType perl noremap <silent> [M :call Perl_method_jump_before()<CR>
" have to work harder for the [M to work. Also add the case where a nr is
" given
" map <silent> [M :call Perl_method_end_jump('b')<CR>

function! Perl_method_jump(type) range
    let l:pattern =  '\v^\s*sub\s*\w+\s*(\(\s*.{-}\s*\))?\s*\n*\{'
    for i in range(1, v:count1)
        call search(l:pattern, a:type . 'W')
    endfor
endfunction

function! Perl_method_jump_before() range
    let l:pattern =  '\v^\s*sub\s*\w+\s*(\(\s*.{-}\s*\))?\s*\n*\{'
    " retrieve the cursor position
    let l:current_pos = getpos(".")
    " keep the counter as it is going to be reset by any normal mode command
    let l:counter = v:count1

    if !(searchpos(l:pattern, 'bceW')[0])
        " no previous subroutine so nothing to do
        return 1
    endif

    " keep this flag to determine if we have any previous method to jump to
    let l:have_previous_method = search(l:pattern, 'nbeW')

    normal %
    if (getpos(".")[1] >= l:current_pos[1])
        if (!l:have_previous_method)
            call setpos(".", l:current_pos)
            " no reason to continue as we don't have any subroutine before us
            return 1
        endif
        let l:counter +=1
    endif
    " if (l:counter == 1)
    "     return 1
    " endif

    if (getpos(".")[1] < l:current_pos[1])
        if (!l:have_previous_method)
            " no reason to continue as we don't have any subroutine before us
            return 1
        endif
    endif

    let l:pos_moved = 0
    for i in range(1, l:counter)
        if (search(l:pattern, 'beW')) " use 'e' flag to jump to the end of match. Important !!
            let l:pos_moved += 1
        endif
    endfor
    " if the value was incremented it means we jumped
    " somewhere on '{' in a 'sub foo {' so we call '%' to 
    " jump to mathcing brace
    if (l:pos_moved)
        normal %
    endif
    " if !(searchpos(l:pattern, 'bceW')[0])
    "     setpos(l:current_pos)
    " endif
    " call Jump_to_nr_of_sub_end(l:counter, l:pattern, 'b')

endfunction

function! Perl_method_end_jump() range
    let l:pattern =  '\v^\s*sub\s*\w+\s*(\(\s*.{-}\s*\))?\s*\n*\{'
    " retrieve the cursor position
    let l:current_pos = getpos(".")
    " keep the counter as it is going to be reset by any normal mode command
    let l:counter = v:count1

    " search backwards first to see if there are any subroutines before cursor
    if !(searchpos(l:pattern, 'bceW')[0])
        " no previous subroutine so jump forward
        call Jump_to_nr_of_sub_end(l:counter, l:pattern, '')
        return 1
    endif

    " keep this flag to determine if we have any succesive methods
    let l:have_next_method = search(l:pattern, 'neW')
    " jump to the end of the previous subroutine
    normal %

    if (getpos(".")[1] <= l:current_pos[1])
        if (!l:have_next_method)
            call setpos(".", l:current_pos)
            " no reason to continue as we don't have any subroutine before us
            return 1
        endif
    endif
    " if this is true we were in a subroutine and we jumped at the end of it
    if (getpos(".")[1] > l:current_pos[1])
        if (!l:have_next_method)
            " no reason to continue as we don't have any subroutine before us
            return 1
        endif
        " if a count was given we need to further jump one less time
        let l:counter -= 1
    endif
    " we were not in a subroutine so we simply jump forward
    call Jump_to_nr_of_sub_end(l:counter, l:pattern, '')
endfunction

function! Jump_to_nr_of_sub_end(jumps, sub_pattern, type)
    " if the count is higher than the nr of possible jumps
    " we jump the max nr we can (default behaviour of ]m)
    let l:pos_moved = 0
    for i in range(1, a:jumps)
        if (search(a:sub_pattern, a:type . 'eW')) " use 'e' flag to jump to the end of match. Important !!
            let l:pos_moved += 1
        endif
    endfor
    " if the value was incremented it means we jumped
    " somewhere on '{' in a 'sub foo {' so we call '%' to 
    " jump to mathcing brace
    if (l:pos_moved)
        normal %
    endif
endfunction

let g:next_method_loaded = 1
