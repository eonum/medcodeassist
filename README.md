# medcodeassist
Assistant for medical coding based on analysis of free text medical documentation

## API

### Tokens

Expects
- text

Returns
- list of {word, token, pos}

### Synonyms
Expects
- token, count (of expected synonyms. Only makes sense because we are approximating synonyms by similar tokens. Will be removed if we switch to a real synonym database)

Returns
- list of simlar tokens ({name, similarity})

Note: At the moment we're approximating synonyms by using similarity-

### Codes
Expects:
- code, count (of similar codes to be returned), minlength (minimal length of the codes to be returned)

Returns
- list of {name, similarity}
