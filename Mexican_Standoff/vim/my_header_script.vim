let s:_42 = [
			\"        :::      ::::::::",
			\"      :+:      :+:    :+:",
			\"    +:+ +:+         +:+  ",
			\"  +#+  +:+       +#+     ",
			\"+#+#+#+#+#+   +#+        ",
			\"     #+#    #+#          ",
			\"    ###   ########.fr    "
			\]

let s:stylebegin = '/*'
let s:styleend = '*/'
let s:fill = '*'
let s:lenline = 80
let	s:margin = 5
let s:user = $USER
let s:mail = $MAIL

if (!s:mail)
	let s:mail = 'marvin@42.fr'
endif

function s:l1 ()
	return (s:stylebegin . repeat(s:fill, s:lenline - strlen(s:stylebegin) * 2) . s:styleend)
endfunction

function s:emptyline ()
	return (s:stylebegin . repeat(' ', s:lenline - strlen(s:stylebegin) * 2) . s:styleend)
endfunction

function s:updateline ()
	let l:text = s:stylebegin . repeat(' ', s:margin - strlen(s:stylebegin)) . "Updated: " . strftime("%Y/%m/%d %H:%M:%S" . " by " . s:user)
	return (l:text . repeat(' ', s:lenline - strlen(l:text) - strlen(s:_42[6]) - s:margin) . s:_42[6] . repeat(' ', s:margin - strlen(s:styleend)) . s:styleend)
endfunction

function s:createline ()
	let l:text = s:stylebegin . repeat(' ', s:margin - strlen(s:stylebegin)) . "Created: " . strftime("%Y/%m/%d %H:%M:%S" . " by " . s:user)
	return (l:text . repeat(' ', s:lenline - strlen(l:text) - strlen(s:_42[5]) - s:margin) . s:_42[5] . repeat(' ', s:margin - strlen(s:styleend)) . s:styleend)
endfunction

function s:emptyline42 (index)
	return (s:stylebegin . repeat(' ', s:lenline - strlen(s:stylebegin) - s:margin - strlen(s:_42[a:index])) . s:_42[a:index] . repeat(' ', s:margin - strlen(s:styleend)) . s:styleend)
endfunction

function s:userline ()
	let l:text = s:stylebegin . repeat(' ', s:margin - strlen(s:stylebegin)) . "By: " . s:user . " <"  . s:mail .  ">"
	return (l:text . repeat(' ', s:lenline - strlen(l:text) - strlen(s:_42[3]) - s:margin) . s:_42[3] . repeat(' ', s:margin - strlen(s:styleend)) . s:styleend)
endfunction

function s:fileline ()
	let l:text = s:stylebegin . repeat(' ', s:margin - strlen(s:stylebegin)) . expand('%:t')
	return (l:text . repeat(' ', s:lenline - strlen(l:text) - strlen(s:_42[1]) - s:margin) . s:_42[1] . repeat(' ', s:margin - strlen(s:styleend)) . s:styleend)
endfunction

function s:updateline_rewrite ()
	if (getbufvar(bufname('%'), "&mod"))
		let l:text = s:stylebegin . repeat(' ', s:margin - strlen(s:stylebegin)) . "Updated: " . strftime("%Y/%m/%d %H:%M:%S" . " by " . s:user)
		let l:updateline = l:text . repeat(' ', s:lenline - strlen(l:text) - strlen(s:_42[5]) - s:margin) . s:_42[5] . repeat(' ', s:margin - strlen(s:styleend)) . s:styleend
		call setline(9, s:updateline())
	endif
endfunction

function s:checkhead ()
	if (getline (1) ==# s:l1 ())
		return (0)
	endif
	if (getline (2) ==# s:emptyline ())
		return (0)
	endif
	if (getline (3) ==# s:emptyline42 (0))
		return (0)
	endif
	if (getline (4) ==# s:fileline ())
		return (0)
	endif
	if (getline(5) ==# s:emptyline42(2))
		return (0)
	endif
	if (getline(6) ==# s:userline())
		return (0)
	endif
	if (getline(7) ==# s:emptyline42(4))
		return (0)
	endif
	if (getline(8) ==# s:createline())
		return (0)
	endif
	if (getline(10) ==# s:emptyline())
		return (0)
	endif
	return (1)
endfunction

function s:swag ()
	if (s:checkhead() ==# 1)
		call append(0, "")
		call append(0, s:l1 ())
		call append(0, s:emptyline ())
		call append(0, s:updateline ())
		call append(0, s:createline ())
		call append(0, s:emptyline42(4))
		call append(0, s:userline())
		call append(0, s:emptyline42(2))
		call append(0, s:fileline())
		call append(0, s:emptyline42(0))
		call append(0, s:emptyline ())
		call append(0, s:l1 ())
	endif
endfunction

command Stdswag call s:swag ()
nmap <C-h> :Stdswag<CR>
autocmd BufWritePre * call s:updateline_rewrite ()
