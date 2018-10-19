# ~Forced evolution for unicellular entities~
# ==Extnesion methods==
Function::getter = (name, proc)	-> Reflect.defineProperty @prototype, name, {get: proc, configurable: true}
Function::setter = (name, proc)	-> Reflect.defineProperty @prototype, name, {set: proc, configurable: true}

#.{ [Classes]
class UI
	store_key	= "last_uni"

	constructor: () ->
		@[elem] = document.getElementById(elem) for elem in ['uni', 'pluri', 'appspace']
		@uni.addEventListener 'input', (e) => @evolve()
		@uni.value = @storage ? ""
		@evolve()
		@appspace.style.visibility = 'visible'
		@uni.focus()

	evolve: () ->
		@pluri.value = (char for char from @parse (@storage = @uni.value) + "\n").join('')[0...-1]

	parse: (text) ->
		[prev, brackets, last_out] = ['\n', 0, '\n']
		for char in text
			out	= ''
			switch 
				when char in '.?!'							# Dot/Exclamation/Question.
					out = if last_out isnt char then char else ''
				when char in '\n'							# Line break.
					out = (if last_out[0] in "\n.?!" then "" else ".") + char
				when char is '('							# Opening bracket.
					brackets++
					out = " " + char
				when char is ')'							# Closing bracket.
					out = if brackets then brackets--; prev = char else ''
				when char is ' '							# Space.
					out = ''
				when char is ','							# Comma.
					out = if last_out isnt char then char else ""
				else 										# Letter/digit/etc.
					out = if prev in '\n' then char.toUpperCase()
					else if prev in '), ' and last_out isnt ' (' then ' ' + char
					else char
			last_out = out if out # Saving last output.
			prev = char	# Saving previous letter.
			yield out	# Returning value.

	# --Properties goes here.
	@getter 'storage', ()		-> localStorage.getItem(store_key)
	@setter 'storage', (val)	-> localStorage.setItem(store_key, val)
#.} [Classes]

# == Main code ==
ui = new UI()